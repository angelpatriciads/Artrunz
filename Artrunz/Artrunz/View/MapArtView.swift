//
//  MapArtView.swift
//  Artrunz
//
//  Created by Angelica Patricia on 23/05/23.
//

import SwiftUI
import CoreLocation
import MapKit
import ConfettiSwiftUI


struct MapArtView: View {
    
    @StateObject var locationManager = LocationManager()
    
    @State private var lastCoordinate: CLLocationCoordinate2D?
    
    @State private var coordinatesList: [CLLocationCoordinate2D] = []
    
    @State private var totalDistance: CLLocationDistance = 0.0
    
    @State private var timer: Timer?
    
    @State private var elapsedTime: TimeInterval = 0.0
    
    @State private var isTimerRunning = false
    
    @State private var showsUserLocation: Bool = true
    
    @State private var isFinished = false
    
    @State private var counter: Int = 1
    
    var userLatitude: String {
        guard let latitude = locationManager.lastLocation?.coordinate.latitude else {
            return "0"
        }
        return String(format: "%.8f", latitude)
    }
    
    var userLongitude: String {
        guard let longitude = locationManager.lastLocation?.coordinate.latitude else {
            return "0"
        }
        return String(format: "%.8f", longitude)
    }
    
    var userSpeed: String {
        guard let speed = locationManager.lastLocation?.speed else {
            return "0"
        }
        return String(format: "%.2f", speed)
    }
    
    var formattedElapsedTime: String {
        let hours = Int(elapsedTime) / 3600
        let minutes = (Int(elapsedTime) % 3600) / 60
        let seconds = (Int(elapsedTime) % 3600) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            
            // MARK: Map
            MapView(locationManager: locationManager, showsUserLocation: showsUserLocation, annotations: createAnnotations(), userTrackingMode: .follow)
                .accentColor(Color("blue"))
                .edgesIgnoringSafeArea(.all)
            
            
            VStack {
                if !isFinished {
                    VStack (spacing: 10) {
                        ZStack {
                            Text("Your Current Location")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.white)
                            
                            HStack {
                                Button(action: {
                                    self.presentationMode.wrappedValue.dismiss()
                                }, label: {
                                    Image(systemName: "chevron.left")
                                        .font(.title2)
                                        .bold()
                                        .foregroundColor(.white)
                                        .shadow(color: .black, radius: 10)
                                        .frame(width: 30, height: 30)
                                })
                                
                                Spacer()
                            }
                        }
                        HStack {
                            Text("Latitude: \(userLatitude)")
                            Text("Longitude: \(userLongitude)")
                        }
                        .font(.footnote)
                        .foregroundColor(.white)
                    }
                    .shadow(color: .black, radius: 10)
                    Spacer()
                    HStack {
                        VStack (alignment: .leading) {
                            Text("Total Distance")
                                .font(.system(size: 20))
                            
                            HStack {
                                Text("\(totalDistance, specifier: "%.2f")")
                                    .font(.system(size: 30))
                                    .bold()
                                
                                VStack {
                                    Spacer()
                                    Text("Meters")
                                        .font(.system(size: 12))
                                }
                            }
                            
                        }
                        
                        Spacer()
                        VStack(alignment: .trailing){
                            Text("Elapsed Time")
                                .font(.system(size: 20))
                            Text("\(formattedElapsedTime)")
                                .font(.system(size: 30))
                                .bold()
                        }
                        
                        
                    }
                    .frame(height: 0)
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 5)
                    .padding(.bottom,20)
                    .padding()
                    
                    HStack {
                        Button(action: {
                            finishButtonTapped()
                        }) {
                            Text("Finish")
                                .frame(width: 140, height: 20)
                                .font(.headline)
                                .padding()
                                .foregroundColor(.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(LinearGradient(colors: [Color("rose"),Color.white], startPoint: .leading, endPoint: .trailing), lineWidth: 3)
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
                else {
                    VStack(spacing:-5) {
                        HStack {
                            VStack (alignment: .leading) {
                                Text("Total Distance")
                                    .font(.system(size: 20))
                                
                                HStack {
                                    Text("\(totalDistance, specifier: "%.2f")")
                                        .font(.system(size: 30))
                                        .bold()
                                    
                                    VStack {
                                        Spacer()
                                        Text("Meters")
                                            .font(.system(size: 12))
                                    }
                                }
                                
                            }
                            
                            Spacer()
                            VStack(alignment: .trailing){
                                Text("Elapsed Time")
                                    .font(.system(size: 20))
                                Text("\(formattedElapsedTime)")
                                    .font(.system(size: 30))
                                    .bold()
                            }
                            
                            
                        }
                        .frame(height: 0)
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 5)
                        .padding(.bottom,20)
                        .padding()
                        Spacer()
                        Text("Take a screenshot now!")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                        
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Text("Back to home")
                                .font(.system(size: 27))
                                .bold()
                                .padding()
                                .foregroundStyle(LinearGradient(colors: [Color("rose"),Color("light-rose")], startPoint: .leading, endPoint: .trailing))
                        })
                    }
                    .onAppear {
                        self.counter += 1
                    }
                    .confettiCannon(counter: $counter, num: 100, openingAngle: Angle(degrees: 0), closingAngle: Angle(degrees: 360), radius: 250)
                }
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        
    }
    
    // MARK: Function
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
    
    private func finishButtonTapped() {
        
        stopTimer()
        showsUserLocation = false
        isFinished = true
        print(coordinatesList)
        let polyline = MKPolyline(coordinates: coordinatesList, count: coordinatesList.count)
        let edgePadding = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
        locationManager.mapView.setVisibleMapRect(polyline.boundingMapRect, edgePadding: edgePadding, animated: true)
        coordinatesList.removeAll()
        print(coordinatesList)
    }
}

struct MapArtView_Previews: PreviewProvider {
    static var previews: some View {
        MapArtView()
    }
}

enum MapDetails {
    static let startingLocation = CLLocationCoordinate2D(latitude: 37.332016, longitude: -121.889654)
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
}

struct MapView: UIViewRepresentable {
    
    
    @ObservedObject var locationManager: LocationManager
    var showsUserLocation: Bool
    var region = MKCoordinateRegion(center: MapDetails.startingLocation, span: MapDetails.defaultSpan)
    var annotations: [MKAnnotation]
    var userTrackingMode: MKUserTrackingMode
    
    func makeUIView(context: Context) -> MKMapView {
        locationManager.mapView.delegate = context.coordinator
        locationManager.mapView.overrideUserInterfaceStyle = .dark
        locationManager.mapView.mapType = .mutedStandard
        locationManager.mapView.showsUserLocation = showsUserLocation
        locationManager.mapView.userTrackingMode = userTrackingMode
        
        return locationManager.mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.showsUserLocation = showsUserLocation
        uiView.removeAnnotations(uiView.annotations)
        uiView.addAnnotations(annotations)
        
//        if isFinished {
//                let polyline = MKPolyline(coordinates: coordinatesList, count: coordinatesList.count)
//                let edgePadding = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
//                uiView.setVisibleMapRect(polyline.boundingMapRect, edgePadding: edgePadding, animated: true)
//            }
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

