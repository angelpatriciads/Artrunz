//
//  ContentView.swift
//  Artrunz
//
//  Created by Angelica Patricia on 23/05/23.
//

import SwiftUI
import MapKit
import Foundation

struct ContentView: View {
    
    @StateObject var locationManager = LocationManager()
    
    @State private var lastCoordinate: CLLocationCoordinate2D?
    
    @State private var coordinatesList: [CLLocationCoordinate2D] = []
    
    @State private var totalDistance: CLLocationDistance = 0.0
    
    @State private var timer: Timer?
    
    @State private var elapsedTime: TimeInterval = 0.0
    
    @State private var isTimerRunning = false
    
    var userLatitude: String {
        guard let latitude = locationManager.lastLocation?.coordinate.latitude else {
            return "0"
        }
        return String(format: "%.10f", latitude)
    }
    
    var userLongitude: String {
        guard let longitude = locationManager.lastLocation?.coordinate.latitude else {
            return "0"
        }
        return String(format: "%.10f", longitude)
    }
    
    var userSpeed: String {
        guard let speed = locationManager.lastLocation?.speed else {
            return "0"
        }
        return String(format: "%.2f", speed)
    }
    
    var formattedElapsedTime: String {
        let minutes = Int(elapsedTime) / 60
        let seconds = Int(elapsedTime) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var body: some View {
        ZStack {
            MapView(locationManager: locationManager, showsUserLocation: true, userTrackingMode: .followWithHeading, annotations: createAnnotations())
                .accentColor(Color("blue"))
                .edgesIgnoringSafeArea(.all)
            
            
            VStack {
                VStack {
                    Text("Your Current Location")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                    Text("location status: \(locationManager.statusString)")
                        .bold()
                        .foregroundColor(.white)
                    HStack {
                        Text("latitude: \(userLatitude)")
                        Text("longitude: \(userLongitude)")
                    }
                    .font(.footnote)
                    .foregroundColor(.white)
                }
                .shadow(color: .black, radius: 10)
                Spacer()
                HStack {
                    Spacer()
                    VStack (alignment: .trailing, spacing: 0){
                        Text("\(userSpeed)")
                            .font(.system(size: 50))
                            .bold()
                            .foregroundColor(.white)
                        Text("Meters per Second")
                            .font(.title3)
                            .foregroundColor(.white)
                        
                        Text("Total Distance: \(totalDistance, specifier: "%.2f") meters")
                            .font(.footnote)
                            .foregroundColor(.white)
                        
                        Text("Elapsed Time: \(formattedElapsedTime)")
                            .font(.footnote)
                            .foregroundColor(.white)
                    }
                }
                .shadow(color: .black, radius: 5)
                .padding(.bottom,20)
                .padding()
                
                HStack {
                    Button(action: {
                        coordinatesList.removeAll()
                        print(coordinatesList)
                        stopTimer()
                    }) {
                        Text("Finish")
                            .frame(width: 140, height: 20)
                            .font(.headline)
                            .padding()
                            .foregroundColor(.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color("rose"), lineWidth: 3)
                            )
                        
                    }
                    .background(Color("rose").opacity(0.2))
                    .cornerRadius(8)
                    
                    Button(action: {
                        addAnnotation()
                        
                        if !isTimerRunning {
                                startTimer()
                            }
                    }) {
                        Text("Add Point")
                            .frame(width: 140, height: 20)
                            .font(.headline)
                            .padding()
                            .foregroundColor(.white)
                        
                    }
                    .background(Color("rose"))
                    .cornerRadius(8)
                    
                }
                .padding(.bottom,30)
                
                
            }
            .padding()
        }
        
    }
    
    private func addAnnotation() {
        if let location = locationManager.lastLocation?.coordinate {
            coordinatesList.append(location)
            print(coordinatesList)
            let pin = MKPointAnnotation()
            pin.coordinate = location
            locationManager.mapView.addAnnotation(pin)
            
            if coordinatesList.count >= 2 {
                addPolyline()
                updateTotalDistance()
            }
        }
    }
    
    private func addPolyline() {
        let coordinates = coordinatesList.map { $0 }
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        locationManager.mapView.addOverlay(polyline)
    }
    
    private func createAnnotations() -> [MKAnnotation] {
        var annotations: [MKAnnotation] = []
        
        for coordinate in coordinatesList {
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotations.append(annotation)
        }
        
        return annotations
    }
    
    private func updateTotalDistance() {
        guard coordinatesList.count >= 2 else {
            totalDistance = 0.0
            return
        }
        
        let lastIndex = coordinatesList.count - 1
        let startLocation = CLLocation(latitude: coordinatesList[lastIndex - 1].latitude, longitude: coordinatesList[lastIndex - 1].longitude)
        let endLocation = CLLocation(latitude: coordinatesList[lastIndex].latitude, longitude: coordinatesList[lastIndex].longitude)
        
        let distance = startLocation.distance(from: endLocation)
        totalDistance += distance
        print("Total Distance: \(totalDistance)")
    }
    
    private func startTimer() {
        isTimerRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            elapsedTime += 1.0
        }
    }

    private func stopTimer() {
        isTimerRunning = false
        timer?.invalidate()
        timer = nil
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

enum MapDetails {
    static let startingLocation = CLLocationCoordinate2D(latitude: 37.332016, longitude: -121.889654)
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
}

struct MapView: UIViewRepresentable {
    
    
    @ObservedObject var locationManager: LocationManager
    var showsUserLocation: Bool
    var userTrackingMode: MKUserTrackingMode
    var region = MKCoordinateRegion(center: MapDetails.startingLocation, span: MapDetails.defaultSpan)
    var annotations: [MKAnnotation]
    
    func makeUIView(context: Context) -> MKMapView {
        locationManager.mapView.delegate = context.coordinator
        locationManager.mapView.overrideUserInterfaceStyle = .dark
        locationManager.mapView.mapType = .mutedStandard
        locationManager.mapView.showsUserLocation = showsUserLocation
        locationManager.mapView.userTrackingMode = userTrackingMode
        
        return locationManager.mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.removeAnnotations(uiView.annotations)
        uiView.addAnnotations(annotations)
    }
    
    typealias UIViewType = MKMapView
    
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: locationManager.mapView)
    }
    
}

extension MapView {
    class MapCoordinator: NSObject, MKMapViewDelegate {
        let parent: MKMapView
        
        init(parent: MKMapView) {
            self.parent = parent
            super.init()
        }
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude), span: MapDetails.defaultSpan)
            parent.setRegion(region, animated: true)
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKGradientPolylineRenderer(overlay: overlay)
            renderer.setColors([UIColor(red: 243/255, green: 128/255, blue: 125/255, alpha: 1), UIColor(red: 21/255, green: 209/255, blue: 224/255, alpha: 1)], locations: [])
            renderer.lineCap = .round
            renderer.lineWidth = 5
            return renderer
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation {
                // Customize the user's current location pin
                let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "userLocation")
                annotationView.image = UIImage(named: "current-pin")
                let transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
                annotationView.transform = transform
                return annotationView
            } else {
                // Customize other annotationsxs
                let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "progressPin")
                annotationView.image = UIImage(named: "progress-pin")
                let transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                annotationView.transform = transform
                
                
                return annotationView
            }
        }
    }
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    @Published var locationStatus: CLAuthorizationStatus?
    @Published var lastLocation: CLLocation?
    let mapView = MKMapView()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = CLActivityType.fitness
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    var statusString: String {
        guard let status = locationStatus else {
            return "unknown"
        }
        
        switch status {
        case .notDetermined: return "notDetermined"
        case .authorizedWhenInUse: return "authorized"
        case .authorizedAlways: return "authorized"
        case .restricted: return "restricted"
        case .denied: return "denied"
        default: return "unknown"
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationStatus = status
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        lastLocation = location
    }
    
}

