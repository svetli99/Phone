//
//  Contact.swift
//  Contacts
//
//  Created by Svetlio on 9.04.21.
//

import UIKit

class Contact: Comparable, Codable {
    var name: String
    
    init(_ name: String) {
        self.name = name
    }
    
    convenience init(random: Bool = false) {
        if random {
            let firstName = ["Asen", "Georgi", "Boris", "Todor"]
            let lastName = ["Ivanov", "Georgiev", "Kostov", "Plamenov"]

            let randomFirstName = firstName.randomElement()!
            let randomLastName = lastName.randomElement()!

            let randomName = "\(randomFirstName) \(randomLastName)"
            
            self.init(randomName)
        } else {
            self.init("")
        }
    }
    
    static func < (lhs: Contact, rhs: Contact) -> Bool {
        lhs.name < rhs.name
    }
    
    static func == (lhs: Contact, rhs: Contact) -> Bool {
        lhs.name == rhs.name
    }
}
