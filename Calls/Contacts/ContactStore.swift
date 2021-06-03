
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
        let sortByDateTaken = NSSortDescriptor(key: #keyPath(Contact.firstName),
                                               ascending: true)
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
    
//    private func fetchAllTags() -> [String] {
//        let fetchRequest: NSFetchRequest<Tag> = Tag.fetchRequest()
//        let sortByName = NSSortDescriptor(key: #keyPath(Tag.name), ascending: true)
//        fetchRequest.sortDescriptors = [sortByName]
//
//        let viewContext = persistentContainer.viewContext
//        var tags: [String] = []
//        viewContext.performAndWait {
//            tags = (try? fetchRequest.execute()) ?? []
//        }
//        return tags
//    }
//
    private func parseJSON(_ contact: Contact) {
        guard let data = contact.json?.data(using: .utf8) else { return }
        
        do {
            let jsonDictionary = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as! Dictionary<String,Dictionary<String,String>>
            
            contact.number = setAttribute(jsonDictionary, "number")
            contact.email = setAttribute(jsonDictionary, "email")
            contact.url = setAttribute(jsonDictionary, "url")
            contact.address = setAttribute(jsonDictionary, "address")
            contact.birthday = setAttribute(jsonDictionary, "birthday")
            contact.date = setAttribute(jsonDictionary, "date")
            contact.relatedName = setAttribute(jsonDictionary, "relatedName")
            contact.instantMessage = setAttribute(jsonDictionary, "instantMessage")
            contact.socialProfile = setAttribute(jsonDictionary, "socialProfile")
            
            
        } catch let error as NSError {
            print(error)
        }
        
    }
    
    private func setAttribute(_ dictionary: [String:[String:String]],_ name: String) -> [(String,String)]? {
        if let dict = dictionary[name] {
            return dict.map { ($0.key,$0.value) }
        }
        return nil
    }
}
