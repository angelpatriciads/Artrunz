//
//  Saving+CoreDataProperties.swift
//  Artrunz
//
//  Created by Angelica Patricia on 24/05/23.
//
//

import Foundation
import CoreData


extension Saving {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Saving> {
        return NSFetchRequest<Saving>(entityName: "Saving")
    }

    @NSManaged public var name: String?
    @NSManaged public var dist: String?
    @NSManaged public var id: Data?
    @NSManaged public var time: String?

}

extension Saving : Identifiable {

}
