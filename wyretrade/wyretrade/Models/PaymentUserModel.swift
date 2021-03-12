//
//  PaymentUserModel.swift
//  wyretrade
//
//  Created by maxus on 3/6/21.
//

import Foundation

struct PaymentUserModel {
    var contact_name: String!
    var email: String!
    var id: Int!
    
    
    init(fromDictionary dictionary: [String: Any]) {
        contact_name = dictionary["contact_name"] as? String
        email = dictionary["contact_email"] as? String
        id = dictionary["id"] as? Int
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary = [String: Any]()
        dictionary["contact_name"] = contact_name
        dictionary["contact_email"] = email
        dictionary["id"] = id
        
        return dictionary
    }
}
