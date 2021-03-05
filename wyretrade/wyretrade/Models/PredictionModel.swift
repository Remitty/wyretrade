//
//  PredictionModel.swift
//  wyretrade
//
//  Created by maxus on 3/4/21.
//

import Foundation

struct PredictionModel {
    var amount: String!
    var price: String!
    var asset: String!
    var type: String!
    var remainTime: String!
    var result: String!
    var payout: String!
    
    init(fromDictionary dictionary: [String: Any]) {
        amount = dictionary["amount"] as? String
        price = dictionary["price"] as? String
        asset = dictionary["asset"] as? String
        type = dictionary["type"] as? String
        remainTime = dictionary["remainTime"] as? String
        result = dictionary["result"] as? String
        payout = dictionary["payout"] as? String
        
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary = [String: Any]()
        dictionary["amount"] = amount
        dictionary["price"] = price
        dictionary["asset"] = asset
        dictionary["type"] = type
        dictionary["remainTime"] = remainTime
        dictionary["result"] = result
        dictionary["payout"] = payout
        
        return dictionary
    }
}
