//
//  Call+CoreDataProperties.swift
//  Calls
//
//  Created by Svetoslav Kanchev on 17.06.21.
//
//

import Foundation
import CoreData


extension Call {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Call> {
        return NSFetchRequest<Call>(entityName: "Call")
    }

    @NSManaged public var name: String?
    @NSManaged public var type: String?
    @NSManaged public var date: [Date]?
    @NSManaged public var inSeriesCount: Int16
    @NSManaged public var isOutcome: Bool
    @NSManaged public var isMissed: Bool
    @NSManaged public var number: String?

}

extension Call : Identifiable {

}
