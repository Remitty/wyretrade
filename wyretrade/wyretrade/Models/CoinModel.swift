//
//  NewsModel.swift
//  wyretrade
//
//  Created by maxus on 3/2/21.
//

import Foundation

struct CoinModel {
    var id: String!
    var name: String!
    var symbol: String!
    var icon: String!
    var price: String!
    var balance: String!
    var holding: String!
    var changeToday: Double! = 0
    
    init?(fromDictionary dictionary: [String: Any]) {
        id = "\(dictionary["id"] as! Int)"
        name = dictionary["coin_name"] as? String
        symbol = dictionary["coin_symbol"] as? String
        icon = dictionary["icon"] as? String
        if !icon.starts(with: "http") {
            icon = Constants.URL.base + icon
        }
        if let coin_rate = dictionary["coin_rate"] as? Double {
            price = PriceFormat.init(amount: coin_rate , currency: Currency.usd).description
        }
//        if coin_rate == nil {
//            price = "0"
//        } else {
//
//        }
        
        balance = CoinFormat.init(value: dictionary["balance"] as! Double, decimal: 4).description
        
        if let est_usdc = dictionary["est_usdc"] as? NSString {
           holding = PriceFormat.init(amount: est_usdc.doubleValue , currency: Currency.usd).description
        }
//        holding = est_usdc == nil ? "0" : PriceFormat.init(amount: (dictionary["est_usdc"] as! NSString).doubleValue , currency: Currency.usd).description
        
        if let change_rate = dictionary["change_rate"] as? NSString {
            changeToday = change_rate.doubleValue
        }
        
//        changeToday = change_rate == nil ? 0 : change_rate.doubleValue
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary = [String: Any]()
        dictionary["name"] = name
        dictionary["symbol"] = symbol
        dictionary["icon"] = icon
        dictionary["price"] = price
        dictionary["balance"] = balance
        dictionary["holding"] = holding
        dictionary["changeToday"] = changeToday
        return dictionary
    }
}
