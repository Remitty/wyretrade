//
//  PredictionModel.swift
//  wyretrade
//
//  Created by maxus on 3/4/21.
//

import Foundation

struct PredictionModel {
    var content: String!
    var price: String!
    var asset: String!
    var remainTime: Int!
    var result: String!
    var payout: String!
    var winner: String!
    var bidder: String!
    var id: String!
    
    
    init(fromDictionary dictionary: [String: Any]) {
        content = dictionary["content"] as? String
        
        if let priceTemp = (dictionary["cu_price"] as? NSString)?.doubleValue {
            price = PriceFormat.init(amount: priceTemp, currency: Currency.usd).description
        } else {
            price = PriceFormat.init(amount: dictionary["cu_price"] as! Double, currency: Currency.usd).description
        }
        asset = dictionary["asset"] as? String
        remainTime = dictionary["day_left"] as! Int
        result = dictionary["status"] as? String
        
//        if let bet_price = (dictionary["bet_price"] as? NSString)?.doubleValue {
//            payout = PriceFormat.init(amount: bet_price, currency: Currency.usd).description
//        } else {
//            payout = PriceFormat.init(amount: dictionary["bet_price"] as! Double, currency: Currency.usd).description
//        }
        payout = "\(dictionary["bet_price"]!) USDC"
        winner = dictionary["winner"] as? String
        bidder = dictionary["bidder"] as? String
        id = "\(dictionary["id"]!)"
    }
    
    
}
