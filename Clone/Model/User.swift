//
//  User.swift
//  Clone
//
//  Created by FARHAN IT SOLUTION on 31/05/17.
//
//

import ObjectMapper

class UserNormal: Mappable {
    
    let ID: Int!
    
    required init?(map: Map) {
        
        do {
            ID = try Int(map.value("univercity_id") as String!)!
        } catch let error {
            print("error:: \(error)")
            return nil
        }
        
    }
    
    func mapping(map: Map) {
        
    }
    
}

class User: NSObject, Mappable, NSCoding {
    
    fileprivate struct Keys {
        static let ID = "userId"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let email = "email"
        static let universityID = "universityID"
        static let universityName = "universityName"
        static let about = "about"
    }
    
    let ID: Int
    let firstName: String!
    let lastName: String!
    let email: String!
    
    let universityID: Int
    let universityName: String!
    let about: String!
    
    var fullName: String {
        return String(format: "%@ %@", firstName, lastName)
    }
    
    required init?(map: Map) {
        
        do {
            
            ID = try Int(map.value("user_id") as String!)!
            firstName = try map.value("user_first_name") as String!
            lastName = try map.value("user_last_name") as String!
            email = try map.value("user_email") as String!
            
            universityID = try Int(map.value("user_univercity_id") as String!)!
            universityName = try map.value("univercity_name") as String!
            
            about = try map.value("user_desc") as String!
            
        } catch let error {
            print("error:: \(error)")
            return nil
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        if let firstName = aDecoder.decodeObject(forKey: Keys.firstName) as? String,
            let lastName = aDecoder.decodeObject(forKey: Keys.lastName) as? String,
            let email = aDecoder.decodeObject(forKey: Keys.email) as? String,
            let universityName = aDecoder.decodeObject(forKey: Keys.universityName) as? String,
            let about = aDecoder.decodeObject(forKey: Keys.about) as? String
        {
            self.ID = aDecoder.decodeInteger(forKey: Keys.ID)
            self.firstName = firstName
            self.lastName = lastName
            self.email = email
            self.universityID = aDecoder.decodeInteger(forKey: Keys.universityID)
            self.universityName = universityName
            self.about = about
        }else{
            return nil
        }
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(ID, forKey: Keys.ID)
        aCoder.encode(firstName, forKey: Keys.firstName)
        aCoder.encode(lastName, forKey: Keys.lastName)
        aCoder.encode(email, forKey: Keys.email)
        aCoder.encode(universityID, forKey: Keys.universityID)
        aCoder.encode(universityName, forKey: Keys.universityName)
        aCoder.encode(about, forKey: Keys.about)
    }
    
    func mapping(map: Map) {
        
    }
    
}
