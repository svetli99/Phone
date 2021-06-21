//
//  Call+CoreDataProperties.swift
//  Calls
//
//  Created by Svetoslav Kanchev on 21.06.21.
//
//

import Foundation
import CoreData


extension Call {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Call> {
        return NSFetchRequest<Call>(entityName: "Call")
    }

    @NSManaged public var callTime: String?
    @NSManaged public var callType: String?
    @NSManaged public var date: Date?
    @NSManaged public var name: String?
    @NSManaged public var number: String?
    @NSManaged public var phoneType: String?

}

extension Call : Identifiable {

}
