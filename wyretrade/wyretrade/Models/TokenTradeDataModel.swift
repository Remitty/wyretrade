//
//  TokenTradeDataModel.swift
//  wyretrade
//
//  Created by brian on 3/19/21.
//

import Foundation
struct TokenTradeDataModel {
    var btcPrice: Double!
    var changeVol: String!
    var changeRate: String!
    var lastHigh: String!
    var lastLow: String!
    var coin1: String!
    var coin2: String!
    var coin1Balance: Double!
    var coin2Balance: Double!
    var maxBid: Ask!
    var orders = [TokenOrderModel]()
    var bids = [Ask]()
    var asks = [Ask]()
    var asksTotal: String!
    var bidsTotal: String!
    var askAggregates = [TokenOrderModel]()
    var bidAggregates = [TokenOrderModel]()
    
    init(fromDictionary dictionary: [String: Any]) {
        
        
        if let price = (dictionary["btc_rate"] as? NSString)?.doubleValue {
            btcPrice = price
        } else {
            btcPrice = dictionary["btc_rate"] as! Double
        }
        
        changeRate = "\(dictionary["change_rate"]!)"
        
        if let high = dictionary["last_high"] as? NSString {
            lastHigh = NumberFormat(value: high.doubleValue, decimal: 6).description
        } else {
            lastHigh = NumberFormat(value: dictionary["last_high"] as! Double, decimal: 6).description
        }
        if let low = dictionary["last_low"] as? NSString {
            lastLow = NumberFormat(value: low.doubleValue, decimal: 6).description
        } else {
            lastLow = NumberFormat(value: dictionary["last_low"] as! Double, decimal: 6).description
        }
        
        coin1 = dictionary["coin1"] as? String
        coin2 = dictionary["coin2"] as? String
        
        if let balance = (dictionary["coin1_balance"] as? NSString)?.doubleValue {
            coin1Balance = (NumberFormat.init(value: balance, decimal: 4).description as! NSString).doubleValue
        } else {
            coin1Balance = (NumberFormat.init(value: dictionary["coin1_balance"] as! Double, decimal: 4).description as! NSString).doubleValue
        }
        
        if let balance = (dictionary["coin2_balance"] as? NSString)?.doubleValue {
            coin2Balance = (NumberFormat.init(value: balance, decimal: 4).description as! NSString).doubleValue
        } else {
            coin2Balance = (NumberFormat.init(value: dictionary["coin2_balance"] as! Double, decimal: 4).description as! NSString).doubleValue
        }
        
        if let data = dictionary["orders"] as? [[String: Any]] {
            for item in data {
                let order = TokenOrderModel(fromDictionary: item)
                orders.append(order)
            }
        }
        if let data = dictionary["bids"] as? [[String: Any]] {
            for item in data {
                let ask = Ask(fromDictionary: item)
                bids.append(ask)
            }
        }
        if let data = dictionary["asks"] as? [[String: Any]] {
            for item in data {
                let ask = Ask(fromDictionary: item)
                asks.append(ask)
            }
        }
        
        if let total = (dictionary["asks_total"] as? NSString)?.doubleValue {
            asksTotal = PriceFormat.init(amount: total, currency: Currency.usd).description
        } else {
            asksTotal = PriceFormat.init(amount: dictionary["asks_total"] as! Double, currency: Currency.usd).description
        }
        if let total = (dictionary["bids_total"] as? NSString)?.doubleValue {
            bidsTotal = PriceFormat.init(amount: total, currency: Currency.usd).description
        } else {
            bidsTotal = PriceFormat.init(amount: dictionary["bids_total"] as! Double, currency: Currency.usd).description
        }
        if let change = (dictionary["change_volume"] as? NSString)?.doubleValue {
            changeVol = PriceFormat.init(amount: change, currency: Currency.usd).description
        } else {
            changeVol = PriceFormat.init(amount: dictionary["change_volume"] as! Double, currency: Currency.usd).description
        }
        if let max = dictionary["max_bid"] as? [String: Any] {
            maxBid = Ask(fromDictionary: max)
        }
        
        if let aggregates = dictionary["aggregates"] as? [String: Any] {
            if let data = aggregates["ask"] as? [[String: Any]] {
                for item in data {
                    let order = TokenOrderModel(fromDictionary: item)
                    askAggregates.append(order)
                }
            }
            if let data = aggregates["bid"] as? [[String: Any]] {
                for item in data {
                    let order = TokenOrderModel(fromDictionary: item)
                    bidAggregates.append(order)
                }
            }
        }
        
        
    }
}
