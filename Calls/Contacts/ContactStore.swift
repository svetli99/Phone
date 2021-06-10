
import UIKit
import CoreData

class ContactStore {
    static var shared = ContactStore()
    
    var allContacts = [(Character, [Contact])]()
    
    lazy var tags = ["mobile","home","work","school","other"]
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Contacts")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("Error setting up Core Data (\(error)).")
            }
        }
        return container
    }()
    
    private init() {
        loadContacts()
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
    
    func contactForNumber(number: String) -> Contact? {
        for section in allContacts {
            for contact in section.1 {
                if contact.number!.contains(where: { $0.1 == number }) {
                    return contact
                }
            }
        }
        return nil
    }
    
    private func loadContacts() {
        let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
        let sortByDateTaken = NSSortDescriptor(key: #keyPath(Contact.firstName),ascending: true)
        fetchRequest.sortDescriptors = [sortByDateTaken]
        
        let viewContext = persistentContainer.viewContext
        viewContext.perform {
            
            do {
                let contacts = try viewContext.fetch(fetchRequest)
                for contact in contacts {
                    let first = contact.firstName!.first!
                    self.parseJSON(contact)
                    
                    if let index = self.allContacts.firstIndex(where: { $0.0 == first }) {
                        self.allContacts[index].1.append(contact)
                    } else {
                        self.allContacts.append((first,[contact]))
                    }
                }
            } catch {
                print("Error loading contacts:",error)
            }
            
        }
    }
    
    func createContact() -> Contact{
        let viewContext = persistentContainer.viewContext
        var newContact: Contact!
        viewContext.performAndWait {
            newContact = Contact(context: viewContext)
        }
        
        return newContact
    }
    
    func addNewContact(contact: Contact) {
        let first = contact.firstName?.first ?? contact.lastName!.first!
        if let section = allContacts.firstIndex(where: { $0.0 == first }) {
            allContacts[section].1.append(contact)
            allContacts[section].1.sort(by: {$0.firstName! < $1.firstName!})
        } else {
            allContacts.append((first,[contact]))
            allContacts.sort(by: {$0.0 < $1.0})
        }
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Core Data save failed: \(error).")
        }
    }
    
    func deleteContact(contact: Contact) {
        let first = contact.firstName?.first ?? contact.lastName!.first!
        let section = allContacts.firstIndex(where: { $0.0 == first })!
        allContacts[section].1.removeAll(where: {$0 == contact})
        if allContacts[section].1.isEmpty {
            allContacts.remove(at: section)
        }
        
        let context = persistentContainer.viewContext
        context.delete(contact)
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Error saving delete contact: \(error)")
        }
        
        
        
    }

    private func parseJSON(_ contact: Contact) {
        guard let data = contact.json?.data(using: .utf8) else { return }
        
        do {
            let jsonDictionary = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as! [String:[String:[String]]]

            contact.jsonDictionary = jsonDictionary
            setAllAttributes(contact)
            
        } catch let error as NSError {
            print(error)
        }
        
    }
    
    private func setAttribute(_ dictionary: [String:[String:[String]]],_ name: String) -> [(String,String)]? {
        if let dict = dictionary[name] {
            return dict.map { ($0.key,$0.value.first!) }
        }
        return nil
    }
    
    private func setAddress(_ dictionary: [String:[String:[String]]]) -> [(String,[String])]?  {
        if let dict = dictionary["Address"] {
            return dict.map { ($0.key,$0.value) }
        }
        return nil
    }
    
    func setAllAttributes(_ contact: Contact) {
        contact.number = setAttribute(contact.jsonDictionary, "Phone")
        contact.email = setAttribute(contact.jsonDictionary, "Email")
        contact.url = setAttribute(contact.jsonDictionary, "URL")
        contact.address = setAddress(contact.jsonDictionary)
        contact.birthday = setAttribute(contact.jsonDictionary, "Birthday")
        contact.date = setAttribute(contact.jsonDictionary, "Date")
        contact.relatedName = setAttribute(contact.jsonDictionary, "Related Name")
        contact.instantMessage = setAttribute(contact.jsonDictionary, "Message")
        contact.socialProfile = setAttribute(contact.jsonDictionary, "Social Profile")
    }
    
    func parseToJSON(_ contact: Contact,_ dict: [String:[String:[String]]]) {
        guard !dict.isEmpty else { return }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            contact.json = String(data: jsonData, encoding: .utf8)
        } catch {
            print("Error parsing dict to data",error)
        }
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Core Data save failed: \(error).")
        }
    }
}
