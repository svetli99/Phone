//
//  Contact.swift
//  Contacts
//
//  Created by Svetlio on 9.04.21.
//

import UIKit

class Contact: Comparable, Codable {
    var name: String
    var number: String
    
    init(_ name: String,_ number: String) {
        self.name = name
        self.number = number
    }
    
    convenience init(random: Bool = false) {
        if random {
            let firstName = ["Asen", "Georgi", "Boris", "Todor"]
            let lastName = ["Ivanov", "Georgiev", "Kostov", "Plamenov"]

            let randomFirstName = firstName.randomElement()!
            let randomLastName = lastName.randomElement()!

            let randomName = "\(randomFirstName) \(randomLastName)"
            let number = "0899001122"
            self.init(randomName,number)
        } else {
            self.init("","0")
        }
    }
    
    static func < (lhs: Contact, rhs: Contact) -> Bool {
        lhs.name < rhs.name
    }
    
    static func == (lhs: Contact, rhs: Contact) -> Bool {
        lhs.name == rhs.name
    }
}
