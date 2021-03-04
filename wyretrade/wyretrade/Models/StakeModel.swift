//
//  StakeModel.swift
//  wyretrade
//
//  Created by maxus on 3/3/21.
//

import Foundation

struct StakeModel {
    var qty: String!
    var type: String!
    var token: String!
    var date: String!
    
    
    init(fromDictionary dictionary: [String: Any]) {
        qty = dictionary["amount"] as? String
        type = dictionary["type"] as? String
        token = dictionary["token"] as? String
        date = dictionary["date"] as? String
        
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary = [String: Any]()
        dictionary["amount"] = qty
        dictionary["type"] = type
        dictionary["token"] = token
        dictionary["date"] = date
        
        return dictionary
    }
}
