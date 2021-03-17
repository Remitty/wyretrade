//
//  MtnModel.swift
//  wyretrade
//
//  Created by maxus on 3/4/21.
//

import Foundation
struct MtnModel {
    
    var status: String!
    var date: String!
    var type: String!
    var amount: String!
    var toPhone: String!
    
    
    init(fromDictionary dictionary: [String: Any]) {
        status = dictionary["status"] as? String
        date = (dictionary["created_at"] as? String)?.date
        type = dictionary["type"] as? String
        amount = "\(dictionary["amount"]!)"
        toPhone = dictionary["to_phone"] as? String
    }
   
}
