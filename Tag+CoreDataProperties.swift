//
//  Tag+CoreDataProperties.swift
//  Calls
//
//  Created by Svetoslav Kanchev on 3.06.21.
//
//

import Foundation
import CoreData


extension Tag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tag> {
        return NSFetchRequest<Tag>(entityName: "Tag")
    }

    @NSManaged public var name: String?

}

extension Tag : Identifiable {

}
