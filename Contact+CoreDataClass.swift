import Foundation
import CoreData

@objc(Contact)
public class Contact: NSManagedObject {
    public var noAttributesItems = ContactNoAttributesItems()
}

public class ContactNoAttributesItems: Codable {
    var phone: [ContactInfoItem]?
    var email: [ContactInfoItem]?
    var url: [ContactInfoItem]?
    var address: [ContactAddress]?
    var birthday: [ContactInfoItem]?
    var date: [ContactInfoItem]?
    var relatedName: [ContactInfoItem]?
    var instantMessage: [ContactInfoItem]?
    var socialProfile: [ContactInfoItem]?
}

public class ContactInfoItem: Codable {
    public var type: String
    var value: String
    var isFavourite: Bool?
    var favouriteDate: Date?
    var favouriteType: String?
    
    init(type: String, value: String, isFavourite: Bool? = nil) {
        self.type = type
        self.value = value
        self.isFavourite = isFavourite
    }
    
}

public struct ContactAddress: Codable {
    public var type: String
    var street1: String
    var street2: String
    var postCode: String
    var city: String
    var country: String
    
    init(type: String,values: [String]) {
        self.type = type
        street1 = values[0]
        street2 = values[1]
        postCode = values[2]
        city = values[3]
        country = values[4]
    }
}

