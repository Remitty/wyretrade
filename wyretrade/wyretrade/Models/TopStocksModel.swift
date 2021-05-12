//
//  TopStocksModel.swift
//  wyretrade
//
//  Created by brian on 5/12/21.
//

import Foundation

struct TopStocksModel {
    var symbol: String!
    var name: String!
    var price: Double!
    var change: String!
    var changePercent: String!
    
    init(fromDictionary dictionary: [String: Any]) {
        
        symbol = dictionary["ticker"] as? String
        name = dictionary["companyName"] as? String
        
        if let priceTemp = (dictionary["price"] as? NSString)?.doubleValue {
            price = priceTemp
        } else {
            price = dictionary["price"] as! Double
        }
        if let changeTemp = (dictionary["changes"] as? NSString)?.doubleValue {
            change = PriceFormat(amount: changeTemp, currency: .usd).description
        } else {
            change = PriceFormat(amount: dictionary["changes"] as! Double, currency: .usd).description
        }
        changePercent = dictionary["changesPercentage"] as? String
    }
}
