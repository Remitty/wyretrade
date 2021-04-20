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
    var status: String!
    var payout: String!
    var winner: String!
    var bidder: String!
    var id: String!
    
    
    init(fromDictionary dictionary: [String: Any]) {
        content = dictionary["content"] as? String
        
        
        asset = dictionary["symbol"] as? String
        remainTime = dictionary["day_left"] as! Int
        status = dictionary["status"] as? String
        
        if status == "Created" || status == "Processing" {
            if let priceTemp = (dictionary["cu_price"] as? NSString)?.doubleValue {
                price = PriceFormat.init(amount: priceTemp, currency: Currency.usd).description
            } else {
                price = PriceFormat.init(amount: dictionary["cu_price"] as! Double, currency: Currency.usd).description
            }
        } else {
            if let priceTemp = (dictionary["result"] as? NSString)?.doubleValue {
                price = PriceFormat.init(amount: priceTemp, currency: Currency.usd).description
            } else {
                price = PriceFormat.init(amount: dictionary["result"] as! Double, currency: Currency.usd).description
            }
        }
        
        
        payout = "\(dictionary["bet_price"]!) USDC"
        winner = dictionary["win"] as? String
        bidder = dictionary["bidder"] as? String
        id = "\(dictionary["id"]!)"
    }
    
    
}
