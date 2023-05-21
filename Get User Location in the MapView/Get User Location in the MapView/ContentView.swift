//
//  ContentView.swift
//  Get User Location in the MapView
//
//  Created by Angelica Patricia on 21/05/23.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        VStack {
            Map(coordinateRegion: $viewModel.region, showsUserLocation: true, userTrackingMode: .constant(.follow))
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    viewModel.checkIfLocationServicesIsEnabled()
                }
                .overlay(
                    MapAnnotationsContainer(mapView: viewModel.mapView)
                )
            
            HStack {
                Button(action: {
                    viewModel.startLocationUpdates()
                }) {
                    Text("Start")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
                 viewModel.stopLocationUpdates()
                 viewModel.annotateRoute()
                    
                }) {
                    Text("Finish")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}

enum MapDetails {
    static let startingLocation = CLLocationCoordinate2D(latitude: 37.331516, longitude: -121.891054)
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.0005, longitudeDelta: 0.0005)
}

final class ContentViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private var isUpdatingLocation = false
    @Published var region = MKCoordinateRegion(center: MapDetails.startingLocation, span: MapDetails.defaultSpan)
    var locationManager: CLLocationManager?
    @Published var locationStatus: CLAuthorizationStatus?
    @Published var lastLocation: CLLocation?
    private var locations: [CLLocation] = []
    let mapView: MKMapView
    
    override init() {
            mapView = MKMapView()
            super.init()
            mapView.delegate = self
        }
    
    func startLocationUpdates() {
            guard !isUpdatingLocation else { return }
            
            isUpdatingLocation = true
            locations.removeAll()
            locationManager?.startUpdatingLocation()
        }
    
    func stopLocationUpdates() {
            guard isUpdatingLocation else { return }
            
            isUpdatingLocation = false
            locationManager?.stopUpdatingLocation()
        }
    
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager?.activityType = CLActivityType.fitness
            locationManager?.requestWhenInUseAuthorization()
            locationManager?.startUpdatingLocation()
        } else {
            print("alert")
        }
        
    }
    
    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }
        
        switch locationManager.authorizationStatus {
        case .notDetermined :
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("restricted")
        case .denied:
            print("denied")
        case .authorizedAlways, .authorizedWhenInUse:
            region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: MapDetails.defaultSpan)
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        lastLocation = location
        print(#function, location)
        self.locations.append(contentsOf: locations)
    }
    
    func annotateRoute() {
        guard let startLocation = locations.first,
              let lastLocation = locations.last else { return }
        
        let startAnnotation = MKPointAnnotation()
        startAnnotation.coordinate = startLocation.coordinate
        startAnnotation.title = "Start"
        
        let finishAnnotation = MKPointAnnotation()
        finishAnnotation.coordinate = lastLocation.coordinate
        finishAnnotation.title = "Finish"
        
        mapView.addAnnotations([startAnnotation, finishAnnotation])
        
        let polyline = MKPolyline(coordinates: locations.map({ $0.coordinate }), count: locations.count)
        mapView.addOverlay(polyline)
    }
}

extension ContentViewModel: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 3
            return renderer
        }
        return MKOverlayRenderer()
    }
}

struct MapAnnotationsContainer: UIViewRepresentable {
    let mapView: MKMapView
    
    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let identifier = "AnnotationView"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
            } else {
                annotationView?.annotation = annotation
            }
            
            return annotationView
        }
    }
}
