//
//  StockPositionModel.swift
//  wyretrade
//
//  Created by maxus on 3/2/21.
//

import Foundation

struct StockPositionModel {
    var ticker: String!
    var name: String!
    var shares: String!
    var price: String!
    var profit: String!
    var holding: String!
    var changeToday: String!
    
    init(fromDictionary dictionary: [String: Any]) {
        name = dictionary["name"] as? String
        ticker = dictionary["ticker"] as? String
        shares = dictionary["shares"] as? String
        price = dictionary["price"] as? String
        profit = dictionary["profit"] as? String
        holding = dictionary["holding"] as? String
        changeToday = dictionary["changeToday"] as? String
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary = [String: Any]()
        dictionary["name"] = name
        dictionary["ticker"] = ticker
        dictionary["shares"] = shares
        dictionary["price"] = price
        dictionary["profit"] = profit
        dictionary["holding"] = holding
        dictionary["changeToday"] = changeToday
        return dictionary
    }
}
