//
//  ContentView.swift
//  Location
//
//  Created by Angelica Patricia on 17/05/23.
//

import MapKit
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        Map(coordinateRegion: $viewModel.region, interactionModes: .all, showsUserLocation: true, userTrackingMode: .constant(.follow), annotationItems: [viewModel.startAnnotation, viewModel.endAnnotation].compactMap { $0 }) { item in
            MapAnnotation(coordinate: item.annotation.coordinate) {
                Image(systemName: "location.circle.fill")
                    .foregroundColor(item.annotation.title == "Start" ? .green : .red)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            viewModel.checkIfLocationServicesIsEnabled()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


