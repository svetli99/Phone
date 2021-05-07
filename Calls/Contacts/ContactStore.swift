//
//  ContactStore.swift
//  Contacts
//
//  Created by Svetlio on 9.04.21.
//

import UIKit

class ContactStore {
    static var shared = ContactStore()
    
    var allContacts = [(Character, [Contact])]()
    let contactsArchiveURL: URL = {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        
        return documentDirectory.appendingPathComponent("contacts.json")
    }()
    
    private init() {
        let notificationCenter = NotificationCenter.default
            notificationCenter.addObserver(self, selector: #selector(saveChanges), name: UIScene.didEnterBackgroundNotification, object: nil)
        do {
            let jsonData = try Data(contentsOf: contactsArchiveURL)
            let contacts = try JSONDecoder().decode([Contact].self, from: jsonData)
            for contact in contacts {
                let first = contact.name.first!
                if let index = allContacts.firstIndex { $0.0 == first } {
                    allContacts[index].1.append(contact)
                    allContacts[index].1.sort()
                } else {
                    allContacts.append((first,[contact]))
                    allContacts.sort { $0.0 < $1.0 }
                }
            }
        } catch {
            print("Error decoding allContacts: \(error)")
        }

    }
    
    @discardableResult func createContact(name: String, number: String) -> Contact? {
        let newContact = Contact(name,number)
        guard let first = newContact.name.first else {
            return nil
        }
        if let index = allContacts.firstIndex { $0.0 == first } {
            allContacts[index].1.append(newContact)
            allContacts[index].1.sort()
        } else {
            allContacts.append((first,[newContact]))
            allContacts.sort { $0.0 < $1.0 }
        }
        
        return newContact
    }
    
    func getNumberOfRows(_ section: Int) -> Int {
        allContacts[section].1.count
    }
    
    func getContact(section: Int, row: Int) -> Contact {
        allContacts[section].1[row]
    }
    
    func getSectoinTittle(section: Int) -> String {
        String(allContacts[section].0)
    }
    
    func contactForNumber(number: String) -> String? {
        for section in allContacts {
            for contact in section.1 {
                if contact.number == number {
                    return contact.name
                }
            }
        }
        return nil
    }
    
    @objc func saveChanges() throws {
        print("Saving items to: \(contactsArchiveURL)")
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(allContacts.flatMap {$1})
            try data.write(to: contactsArchiveURL, options: [.atomic])
        } catch let encodingError {
            throw encodingError
        }
    }
}
