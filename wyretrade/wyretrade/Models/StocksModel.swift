//
//  StockModel.swift
//  wyretrade
//
//  Created by maxus on 3/4/21.
//

import Foundation

struct StocksModel {
    var ticker: String!
    var name: String!
    var shares: String!
    var price: String!
    var changeToday: String!
    
    init(fromDictionary dictionary: [String: Any]) {
        name = dictionary["name"] as? String
        ticker = dictionary["ticker"] as? String
        shares = dictionary["shares"] as? String
        price = dictionary["price"] as? String
        changeToday = dictionary["changeToday"] as? String
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary = [String: Any]()
        dictionary["name"] = name
        dictionary["ticker"] = ticker
        dictionary["shares"] = shares
        dictionary["price"] = price
        dictionary["changeToday"] = changeToday
        return dictionary
    }
}
