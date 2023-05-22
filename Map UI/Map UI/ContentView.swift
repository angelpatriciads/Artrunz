//
//  ContentView.swift
//  Map UI
//
//  Created by Angelica Patricia on 22/05/23.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    @StateObject var locationManager = LocationManager()
    
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
    
    var body: some View {
        ZStack {
            MapView(showsUserLocation: true, userTrackingMode: .followWithHeading)
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
                    Button(action: {
                        
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
    
    var showsUserLocation: Bool
    var userTrackingMode: MKUserTrackingMode
    var region = MKCoordinateRegion(center: MapDetails.startingLocation, span: MapDetails.defaultSpan)
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.overrideUserInterfaceStyle = .dark
        mapView.mapType = .mutedStandard
        mapView.showsUserLocation = showsUserLocation
        mapView.userTrackingMode = userTrackingMode
        
        _ = CLLocationCoordinate2D(latitude: 37.331516, longitude: -121.891054)
        
        
        mapView.setRegion(region, animated: true)
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
    }
    
    typealias UIViewType = MKMapView
    
    
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    @Published var locationStatus: CLAuthorizationStatus?
    @Published var lastLocation: CLLocation?
    @Published var region = MKCoordinateRegion()
    
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
        print(#function, statusString)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        lastLocation = location
        print(#function, location)
    }
}

