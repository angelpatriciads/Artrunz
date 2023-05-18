//
//  AnnotationItems.swift
//  Location
//
//  Created by Angelica Patricia on 17/05/23.
//

import SwiftUI
import CoreLocation
import MapKit

struct AnnotationItems: View {
    struct Landmark: Identifiable {
        let id: String
        let coordinate: CLLocationCoordinate2D
    }
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.773972, longitude: -122.431297), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    
    let landmarks: [Landmark] = [
        Landmark(id: "1", coordinate: CLLocationCoordinate2D(latitude: 37.773972, longitude: -122.431297)),
        Landmark(id: "2", coordinate: CLLocationCoordinate2D(latitude: 37.774806, longitude: -122.420406)),
        // Add more landmark annotations as needed
    ]

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: landmarks) { landmark in
            MapAnnotation(coordinate: landmark.coordinate) {
                Image(systemName: "mappin")
                    .foregroundColor(.red)
            }
        }
    }
}

struct AnnotationItems_Previews: PreviewProvider {
    static var previews: some View {
        AnnotationItems()
    }
}
