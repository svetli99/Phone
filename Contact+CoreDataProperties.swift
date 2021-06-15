import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var company: String?
    @NSManaged public var firstName: String?
    @NSManaged public var json: String?
    @NSManaged public var lastName: String?
    @NSManaged public var notes: String?

}

extension Contact : Identifiable {

}
