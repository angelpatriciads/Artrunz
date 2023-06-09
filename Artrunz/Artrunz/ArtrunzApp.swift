//
//  ArtrunzApp.swift
//  Artrunz
//
//  Created by Angelica Patricia on 23/05/23.
//

import SwiftUI

@main
struct ArtrunzApp: App {
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
