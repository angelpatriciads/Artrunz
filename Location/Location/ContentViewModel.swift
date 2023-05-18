//
//  ContentViewModel.swift
//  Location
//
//  Created by Angelica Patricia on 17/05/23.
//

import Foundation
import MapKit

enum MapDetails {
    static let startingLocation = CLLocationCoordinate2D(latitude: 37.331516, longitude: -121.891054)
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
}

struct AnnotationItem: Identifiable {
    let id = UUID()
    let annotation: MKPointAnnotation
}

final class ContentViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var region = MKCoordinateRegion(center: MapDetails.startingLocation, span: MapDetails.defaultSpan)

    @Published var startAnnotation: AnnotationItem?
    @Published var endAnnotation: AnnotationItem?

    var locationManager: CLLocationManager?
    
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
        } else {
            print("Show an alert letting the user know that location services are off and to go turn them on.")
        }
    }

    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }

        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Your location is restricted, likely due to parental controls.")
        case .denied:
            print("You have denied this app location permission. Go into settings to change it.")
        case .authorizedAlways, .authorizedWhenInUse:
            if let location = locationManager.location {
                region = MKCoordinateRegion(center: location.coordinate, span: MapDetails.defaultSpan)
                addStartAndEndAnnotations()
            }
        @unknown default:
            break
        }
    }

    private func addStartAndEndAnnotations() {
        let startAnnotation = MKPointAnnotation()
        startAnnotation.coordinate = MapDetails.startingLocation
        startAnnotation.title = "Start"
        
        let endAnnotation = MKPointAnnotation()
        endAnnotation.coordinate = region.center
        endAnnotation.title = "End"
        
        self.startAnnotation = AnnotationItem(annotation: startAnnotation)
        self.endAnnotation = AnnotationItem(annotation: endAnnotation)
    }
}
