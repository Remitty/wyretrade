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
    var status: String!
    var shares: String!
    var amount: String!
    var date: String!
    
    init(fromDictionary dictionary: [String: Any]) {
        type = dictionary["type"] as? String
        ticker = dictionary["ticker"] as? String
        shares = dictionary["shares"] as? String
        amount = dictionary["amount"] as? String
        status = dictionary["status"] as? String
        date = dictionary["date"] as? String
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
