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
    
    init(fromDictionary dictionary: [String: Any]) {
        id = "\(dictionary["id"] as! Int)"
        name = dictionary["coin_name"] as? String
        symbol = dictionary["coin_symbol"] as? String
        icon = dictionary["icon"] as? String
        if !icon.starts(with: "http") {
            icon = Constants.URL.base + icon
        }
        price = PriceFormat.init(amount: dictionary["coin_rate"] as! Double , currency: Currency.usd).description
        balance = CoinFormat.init(value: dictionary["balance"] as! Double, decimal: 4).description
        holding = PriceFormat.init(amount: (dictionary["est_usdc"] as! NSString).doubleValue , currency: Currency.usd).description
        changeToday = (dictionary["change_rate"] as! NSString).doubleValue
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
