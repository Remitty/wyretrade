//
//  UserProfileModel.swift
//  wyretrade
//
//  Created by brian on 3/15/21.
//

import Foundation


struct UserProfileModel {

    var dob: String!
    var address: String!
    var address2: String!
    var city: String!
    var country: String!
    var state: String!
    var national: String!
    var postal_code: String!
    
    init(fromDictionary dictionary: [String: Any]) {
        
        dob = dictionary["dob"] as? String
        address = dictionary["address"] as? String
        address2 = dictionary["address2"] as? String
        city = dictionary["city"] as? String
        state = dictionary["state"] as? String
        country = dictionary["country"] as? String
        national = dictionary["region"] as? String
        postal_code = dictionary["postalcode"] as? String
        
        
    }
    
    
}
