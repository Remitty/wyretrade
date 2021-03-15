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
    var dbPrice: Double!
    var avgPrice: String!
    var profit: String!
    var dbProfit: Double!
    var holding: String!
    var changeToday: Double!
    var changeTodayPercent: Double!
    
    init(fromDictionary dictionary: [String: Any]) {
        name = dictionary["name"] as? String
        ticker = dictionary["symbol"] as? String
        shares = dictionary["filled_qty"] as? Double
//        price = PriceFormat(amount: dictionary["current_price"] as! Double, currency: Currency.usd).description
        price = PriceFormat(amount: (dictionary["current_price"] as! NSString).doubleValue, currency: Currency.usd).description
        dbPrice = (dictionary["current_price"] as! NSString).doubleValue
        avgPrice = PriceFormat(amount: (dictionary["avg_price"] as! NSString).doubleValue, currency: Currency.usd).description
        
        holding = PriceFormat(amount: (dictionary["holding"] as! NSString).doubleValue, currency: Currency.usd).description
        if let changeTodayTemp = (dictionary["change"] as? NSString)?.doubleValue {
            changeToday = (NumberFormat.init(value: changeTodayTemp, decimal: 4).description as! NSString).doubleValue
        } else {
            changeToday = (NumberFormat.init(value: dictionary["change"] as! Double, decimal: 4).description as! NSString).doubleValue
        }
        
        if let changeTodayPercentTemp = (dictionary["change_percent"] as? NSString)?.doubleValue {
            changeTodayPercent = (NumberFormat.init(value: changeTodayPercentTemp, decimal: 4).description as! NSString).doubleValue
        } else {
            changeTodayPercent = (NumberFormat.init(value: dictionary["change_percent"] as! Double, decimal: 4).description as! NSString).doubleValue
        }
        
        if let profitTemp = (dictionary["profit"] as? NSString)?.doubleValue {
            dbProfit = profitTemp
            profit = PriceFormat(amount: dbProfit, currency: Currency.usd).description
        } else {
            dbProfit = dictionary["profit"] as? Double
            profit = PriceFormat(amount: dbProfit, currency: Currency.usd).description
        }
        
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
