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
    var address: String!
    var holding: String!
    var changeToday: Double!
    var withdrawFee: Double!
    var buyType: Int!
    var exchangeRate: Double!
    var type: String!
    var secretSeed: String!
    
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
        
        if let fee = dictionary["withdrawal_fee"] as? Double {
            withdrawFee = fee
        }
        
        if let balanceTemp = (dictionary["balance"] as? NSString)?.doubleValue {
            balance = NumberFormat.init(value: balanceTemp, decimal: 4).description
        } else {
            balance = NumberFormat.init(value: dictionary["balance"] as! Double, decimal: 4).description
        }
        
        if let est_usdc = dictionary["est_usdc"] as? NSString {
           holding = PriceFormat.init(amount: est_usdc.doubleValue , currency: Currency.usd).description
        }
        
        if let change_rate = dictionary["change_rate"] as? NSString {
            changeToday = change_rate.doubleValue
        }
        
        if let exchange = dictionary["exchange_rate"] as? NSString {
            exchangeRate = exchange.doubleValue
        }
        
        if let addressTemp = dictionary["address"] as? String {
            address = addressTemp
        }
        
        if let secret = dictionary["stellar_secret"] as? String {
            secretSeed = secret
        }
        
        buyType = dictionary["buy_now"] as? Int
        
        type = dictionary["type"] as? String
        
    }
   
}
