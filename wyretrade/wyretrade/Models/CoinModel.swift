//
//  NewsModel.swift
//  wyretrade
//
//  Created by maxus on 3/2/21.
//

import Foundation

struct CoinModel {
    var name: String!
    var image: String!
    var price: String!
    var balance: String!
    var holding: String!
    var changeToday: String!
    
    init(fromDictionary dictionary: [String: Any]) {
        name = dictionary["name"] as? String
        image = dictionary["image"] as? String
        price = dictionary["price"] as? String
        balance = dictionary["balance"] as? String
        holding = dictionary["holding"] as? String
        changeToday = dictionary["changeToday"] as? String
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary = [String: Any]()
        dictionary["name"] = name
        dictionary["image"] = image
        dictionary["price"] = price
        dictionary["balance"] = balance
        dictionary["holding"] = holding
        dictionary["changeToday"] = changeToday
        return dictionary
    }
}
