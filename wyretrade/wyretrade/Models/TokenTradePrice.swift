//
//  TokenTradePrice.swift
//  wyretrade
//
//  Created by brian on 3/18/21.
//

import Foundation

struct TokenTradePrice {
    var type: String!
    var pair: String!
    var price: String!
    var date: String!
    
    init(fromDictionary dictionary: [String: Any]) {
        type = dictionary["type"] as? String
        pair = dictionary["pair"] as? String
        
        if let priceTemp = dictionary["rate"] as? NSString {
            price = NumberFormat(value: priceTemp.doubleValue, decimal: 8).description
        } else {
            price = NumberFormat(value: dictionary["rate"] as! Double, decimal: 8).description
        }
        
        date = (dictionary["updated_at"] as! String).date
    }
}
