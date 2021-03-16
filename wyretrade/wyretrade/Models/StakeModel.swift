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
        qty = "\(dictionary["amount"]!)"
        type = dictionary["type"] as? String
        token = dictionary["asset"] as? String
        date = (dictionary["updated_at"] as! String).date
        
    }
   
}
