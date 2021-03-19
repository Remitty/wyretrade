//
//  Ask.swift
//  wyretrade
//
//  Created by brian on 3/19/21.
//

import Foundation

struct Ask {
    
    var qty: String!
    var price: String!
    
    
    init(fromDictionary dictionary: [String: Any]) {
        
        qty = "\(dictionary["quantity"]!)"
        price = "\(dictionary["price"]!)"
        if let quantity = (dictionary["quantity"] as? NSString)?.doubleValue {
            qty = NumberFormat.init(value: quantity, decimal: 4).description
        } else {
            qty = NumberFormat.init(value: dictionary["quantity"] as! Double, decimal: 4).description
        }
        if let priceTemp = (dictionary["price"] as? NSString)?.doubleValue {
            price = NumberFormat.init(value: priceTemp, decimal: 12).description
        } else {
            price = NumberFormat.init(value: dictionary["price"] as! Double, decimal: 12).description
        }
    }
}
