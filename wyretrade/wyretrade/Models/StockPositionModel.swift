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
    var shares: Double!
    var price: String!
    var avgPrice: String!
    var profit: String!
    var holding: String!
    var changeToday: Double!
    var changeTodayPercent: Double!
    
    init(fromDictionary dictionary: [String: Any]) {
        name = dictionary["name"] as? String
        ticker = dictionary["symbol"] as? String
        shares = dictionary["filled_qty"] as? Double
        price = PriceFormat(amount: (dictionary["current_price"] as! NSString).doubleValue, currency: Currency.usd).description
        avgPrice = PriceFormat(amount: (dictionary["avg_price"] as! NSString).doubleValue, currency: Currency.usd).description
        profit = PriceFormat(amount: (dictionary["profit"] as! NSString).doubleValue, currency: Currency.usd).description
        holding = PriceFormat(amount: (dictionary["holding"] as! NSString).doubleValue, currency: Currency.usd).description
        changeToday = (dictionary["change"] as! NSString).doubleValue
        changeTodayPercent = (dictionary["change_percent"] as! NSString).doubleValue
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
