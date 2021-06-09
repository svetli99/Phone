//
//  Contact+CoreDataClass.swift
//  Calls
//
//  Created by Svetoslav Kanchev on 3.06.21.
//
//

import Foundation
import CoreData

@objc(Contact)
public class Contact: NSManagedObject {
    public var number: [(String, String)]?
    public var email: [(String, String)]?
    public var url: [(String, String)]?
    public var address: [(String, [String])]?
    public var birthday: [(String, String)]?
    public var date: [(String, String)]?
    public var relatedName: [(String, String)]?
    public var instantMessage: [(String, String)]?
    public var socialProfile: [(String, String)]?
    public var jsonDictionary: [String:[String:[String]]]!
}
