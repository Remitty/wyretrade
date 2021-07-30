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
    var countryCode: String!
    var email: String!
    var dob: String!
    var address: String!
    var address2: String!
    var city: String!
    var country: String!
    var state: String!
    var national: String!
    var postal_code: String!
    var profile: UserProfileModel!
    
    init(fromDictionary dictionary: [String: Any]) {
        profile = UserProfileModel.init(fromDictionary:dictionary["profile"] as! [String : Any])
        first_name = dictionary["first_name"] as? String
        last_name = dictionary["last_name"] as? String
        phone = dictionary["mobile"] as? String
        countryCode = dictionary["country_code"] as? String
        email = dictionary["email"] as? String
        dob = profile.dob
        address = profile.address
        address2 = profile.address2
        city = profile.city
        country = profile.country
        state = profile.state
        national = profile.national
        postal_code = profile.postal_code
        
        
    }
    
    
}
