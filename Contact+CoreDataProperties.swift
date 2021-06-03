//
//  Contact+CoreDataProperties.swift
//  Calls
//
//  Created by Svetoslav Kanchev on 3.06.21.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var notes: String?
    @NSManaged public var company: String?
    @NSManaged public var json: String?

}

extension Contact : Identifiable {

}
