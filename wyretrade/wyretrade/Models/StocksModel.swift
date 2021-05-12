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
    var shares: Double!
    var price: String!
    var avgPrice: String!
    var changeToday: String!
    var changeTodayPercent: Double!
    
    
    init(fromDictionary dictionary: [String: Any]) {
        name = dictionary["name"] as? String
        ticker = dictionary["symbol"] as? String
        shares = dictionary["shares"] as? Double
        price = PriceFormat(amount: dictionary["vw"] as! Double, currency: Currency.usd).description
        avgPrice = PriceFormat(amount: (dictionary["filled_avg_price"] as! NSString).doubleValue, currency: Currency.usd).description
        changeToday = PriceFormat(amount: dictionary["todaysChange"] as! Double, currency: Currency.usd).description
        changeTodayPercent = dictionary["todaysChangePerc"] as! Double
        
    }
    
}
