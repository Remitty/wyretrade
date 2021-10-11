//
//  PredictAssetModel.swift
//  wyretrade
//
//  Created by brian on 3/24/21.
//

import Foundation

struct PredictAssetModel {
    var id: String!
    var name: String!
    var symbol: String!
    var icon: String!
    var price: String!
    var changeToday: String!
    
    init?(fromDictionary dictionary: [String: Any]) {
//        id = "\(dictionary["id"] as! Int)"
        name = dictionary["name"] as? String
        symbol = dictionary["symbol"] as? String
        icon = dictionary["icon"] as? String
        if !icon.starts(with: "http") {
            icon = Constants.URL.base + icon
        }
        if let coin_rate = dictionary["price"] as? NSString {
            price = PriceFormat.init(amount: coin_rate.doubleValue , currency: Currency.usd).description
        } else {
            price = PriceFormat.init(amount: dictionary["price"] as! Double , currency: Currency.usd).description
        }
        
        if let change_rate = dictionary["change"] as? NSString {
            changeToday = NumberFormat(value: change_rate.doubleValue, decimal: 4).description + " %"
        } else {
            changeToday = NumberFormat(value: dictionary["change"] as! Double, decimal: 4).description + " %"
        }
        
       
        
    }
   
}
