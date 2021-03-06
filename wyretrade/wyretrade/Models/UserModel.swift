//
//  UserModel.swift
//  wyretrade
//
//  Created by maxus on 3/6/21.
//

import Foundation
struct UserModel {
    var first_name: String!
    var last_name: String!
    var phone: String!
    var email: String!
    var dob: String!
    var address: String!
    var address2: String!
    var city: String!
    var country: String!
    var national: String!
    var postal_code: String!
    
    init(fromDictionary dictionary: [String: Any]) {
        first_name = dictionary["first_name"] as? String
        last_name = dictionary["last_name"] as? String
        phone = dictionary["phone"] as? String
        email = dictionary["email"] as? String
        dob = dictionary["dob"] as? String
        address = dictionary["address"] as? String
        address2 = dictionary["address2"] as? String
        city = dictionary["city"] as? String
        country = dictionary["country"] as? String
        national = dictionary["national"] as? String
        postal_code = dictionary["postal_code"] as? String
        
        
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary = [String: Any]()
        dictionary["first_name"] = first_name
        dictionary["last_name"] = last_name
        dictionary["phone"] = phone
        dictionary["email"] = email
        dictionary["dob"] = dob
        dictionary["address"] = address
        dictionary["address2"] = address2
        dictionary["city"] = city
        dictionary["country"] = country
        dictionary["national"] = national
        dictionary["postal_code"] = postal_code
        
        
        return dictionary
    }
}
