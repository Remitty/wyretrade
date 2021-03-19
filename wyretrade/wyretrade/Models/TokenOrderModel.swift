//
//  TokenOrderModel.swift
//  wyretrade
//
//  Created by brian on 3/18/21.
//

import Foundation

struct TokenOrderModel {
    var type: String!
    var pair: String!
    var qty: String!
    var price: String!
    var id: String!
    var date: String!
    
    init(fromDictionary dictionary: [String: Any]) {
        type = dictionary["type"] as? String
        pair = dictionary["pair"] as? String
        qty = "\(dictionary["quantity"]!)"
        price = "\(dictionary["price"]!)"
        id = "\(dictionary["id"]!)"
        date = (dictionary["updated_at"] as! String).date
    }
}
