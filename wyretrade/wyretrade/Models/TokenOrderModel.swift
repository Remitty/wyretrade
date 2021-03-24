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
    var price: Double!
    var id: String!
    var date: String!
    
    init(fromDictionary dictionary: [String: Any]) {
        type = dictionary["type"] as? String
        pair = dictionary["pair"] as? String
        qty = "\(dictionary["quantity"]!)"
        if let priceTemp = dictionary["price"] as? NSString {
            price = priceTemp.doubleValue
        } else {
            price = dictionary["price"] as? Double
        }
        id = "\(dictionary["id"]!)"
        date = (dictionary["updated_at"] as! String).date
    }
}
