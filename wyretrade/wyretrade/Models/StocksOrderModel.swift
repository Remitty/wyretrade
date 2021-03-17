//
//  StocksOrderModel.swift
//  wyretrade
//
//  Created by maxus on 3/5/21.
//

import Foundation

struct StocksOrderModel {
    var ticker: String!
    var type: String!
    var side: String!
    var status: String!
    var shares: Double!
    var amount: Double!
    var date: String!
    var orderId: String!
    var limitPrice: Double!
    
    init(fromDictionary dictionary: [String: Any]) {
        type = dictionary["type"] as? String
        ticker = dictionary["symbol"] as? String
        
       
        if let cost = (dictionary["est_cost"] as? NSString)?.doubleValue {
            amount = cost
        } else {
            amount = dictionary["est_cost"] as! Double
        }
        status = dictionary["status"] as? String
        date = (dictionary["created_at"] as! String).date
        orderId = dictionary["order_id"] as? String
        side = dictionary["side"] as? String
        
        if let limit = (dictionary["limit_price"] as? NSString)?.doubleValue {
            limitPrice = Double(NumberFormat.init(value: limit, decimal: 2).description)
        } else {
            limitPrice = Double(NumberFormat.init(value: dictionary["limit_price"] as! Double, decimal: 2).description)
        }
        if let qty = (dictionary["qty"] as? NSString)?.doubleValue {
            shares = qty
        } else {
            shares = dictionary["qty"] as! Double
        }
        
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary = [String: Any]()
        dictionary["type"] = type
        dictionary["ticker"] = ticker
        dictionary["shares"] = shares
        dictionary["amount"] = amount
        dictionary["status"] = status
        dictionary["date"] = date
        return dictionary
    }
}
