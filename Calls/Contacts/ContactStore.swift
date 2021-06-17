
import UIKit
import CoreData

class ContactStore {
    static var shared = ContactStore()
    
    var allContacts = [Contact]() {
        didSet {
            var grContacts = [(Character,[Contact])]()
            for contact in allContacts {
                let first = contact.firstName!.first!
                self.parseJSON(contact)
                
                if let index = grContacts.firstIndex(where: { $0.0 == first }) {
                    grContacts[index].1.append(contact)
                } else {
                    grContacts.append((first,[contact]))
                }
            }
            groupedContacts = grContacts
        }
    }
    
    var groupedContacts = [(Character, [Contact])]() 
    
    var favouriteContacts = [(Contact,ContactInfoItem)]()
    
    var tags = ["mobile","home","work","school","other"]
    
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
        updateFavourites()
    }
    
    func getNumberOfRows(_ section: Int) -> Int {
        groupedContacts[section].1.count
    }
    
    func getContact(section: Int, row: Int) -> Contact {
        groupedContacts[section].1[row]
    }
    
    func getSectoinTittle(section: Int) -> String {
        String(groupedContacts[section].0)
    }
    
    func getContact(for number: String) -> Contact? {
        for contact in allContacts {
            if let numbers = contact.noAttributesItems.phone, numbers.contains(where: { $0.value == number }) {
                return contact
            }
        }
        return nil
    }
    
    private func loadContacts() {
        let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
        let sortByDateTaken = NSSortDescriptor(key: #keyPath(Contact.firstName),ascending: true)
        fetchRequest.sortDescriptors = [sortByDateTaken]
        
        let viewContext = persistentContainer.viewContext
        viewContext.performAndWait {
            
            do {
                allContacts = try viewContext.fetch(fetchRequest)
                
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
        if let index = allContacts.firstIndex(where: { ($0.firstName ?? $0.lastName!) > (contact.firstName ?? contact.lastName!) }) {
            allContacts.insert(contact, at: index)
        } else {
            allContacts.append(contact)
        }
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Core Data save failed: \(error).")
        }
    }
    
    func deleteContact(contact: Contact) {
        allContacts.removeAll(where: { $0 == contact })
        
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
            let jsonDecoder = JSONDecoder()
            contact.noAttributesItems = try jsonDecoder.decode(ContactNoAttributesItems.self, from: data)
            
            //setAllAttributes(contact,noAttributesItems)
            
        } catch let error as NSError {
            print(error)
        }
        
    }
    
    func parseToJSON(_ contact: Contact) {
        do {
            let jsonEncoder = JSONEncoder()
            jsonEncoder.outputFormatting = .prettyPrinted
            let jsonData = try JSONEncoder().encode(contact.noAttributesItems)
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
    
    func updateFavourites() {
        var favContacts = [(Contact,ContactInfoItem)]()
        for contact in allContacts {
            if let numbers = contact.noAttributesItems.phone {
                for number in numbers where number.isFavourite! {
                    favContacts.append((contact,number))
                }
            }
            if let emails = contact.noAttributesItems.email {
                for email in emails where email.isFavourite! {
                    favContacts.append((contact,email))
                }
            }
        }
        favouriteContacts = favContacts.sorted(by: { pair1, pair2 in
            pair1.1.favouriteDate! < pair2.1.favouriteDate!
        })
    }
}
