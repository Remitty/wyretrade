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
        
        if let quantity = dictionary["quantity"] as? NSString {
            qty = NumberFormat(value: quantity.doubleValue, decimal: 6).description
        } else {
            qty = NumberFormat(value: dictionary["quantity"] as! Double, decimal: 6).description
        }
        if let priceTemp = dictionary["price"] as? NSString {
            price = NumberFormat(value: priceTemp.doubleValue, decimal: 8).description
        } else {
            price = NumberFormat(value: dictionary["price"] as! Double, decimal: 8).description
        }
        id = "\(dictionary["id"]!)"
        date = (dictionary["updated_at"] as! String).date
    }
}
