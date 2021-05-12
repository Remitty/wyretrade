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
    var yearHigh: String!
    var yearLow: String!
    var lastVolume: String!
    
    init(fromDictionary dictionary: [String: Any]) {
        name = dictionary["name"] as? String
        ticker = dictionary["symbol"] as? String
        shares = dictionary["filled_qty"] as? Double

        if let priceTemp = (dictionary["current_price"] as? NSString)?.doubleValue {
            price = PriceFormat(amount: priceTemp, currency: Currency.usd).description
            dbPrice =  priceTemp
        } else {
            price = PriceFormat(amount: dictionary["current_price"] as! Double, currency: Currency.usd).description
            dbPrice = dictionary["current_price"] as! Double
        }
        
        if let avgPriceTemp = (dictionary["avg_price"] as? NSString)?.doubleValue {
            avgPrice = PriceFormat(amount: avgPriceTemp, currency: Currency.usd).description
            
        } else {
            avgPrice = PriceFormat(amount: dictionary["avg_price"] as! Double, currency: Currency.usd).description
            
        }
        
        if let holdingTemp = (dictionary["holding"] as? NSString)?.doubleValue {
            holding = PriceFormat(amount: holdingTemp, currency: Currency.usd).description
            
        } else {
            holding = PriceFormat(amount: dictionary["holding"] as! Double, currency: Currency.usd).description
            
        }
        
        
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
        if let year = dictionary["year_high"] as? Double {
            yearHigh = PriceFormat(amount: dictionary["year_high"] as! Double, currency: Currency.usd).description
            yearLow = PriceFormat(amount: dictionary["year_low"] as! Double, currency: Currency.usd).description
            lastVolume = NumberFormat(value: dictionary["daily_volume"] as!Double, decimal: 4).description
        }
        
        
    }
    
}
