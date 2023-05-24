//
//  PersistentController.swift
//  Artrunz
//
//  Created by Angelica Patricia on 24/05/23.
//

import CoreData

class PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    private init() {
        container = NSPersistentContainer(name: "SavingImgDatabase")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
}
