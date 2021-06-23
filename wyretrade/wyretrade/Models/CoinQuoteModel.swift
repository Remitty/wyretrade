//
//  CoinQuote.swift
//  wyretrade
//
//  Created by brian on 6/21/21.
//

import Foundation

struct CoinQuoteModel {
    var open: String!
    var high: String!
    var low: String!
    var last: String!
    var ask: String!
    var bid: String!
    
    init?(fromDictionary dictionary: [String: Any]) {
        
        if let balanceTemp = (dictionary["openPrice"] as? NSString)?.doubleValue {
            open = "$ " + NumberFormat.init(value: balanceTemp, decimal: 4).description
        } else {
            open = "$ " + NumberFormat.init(value: dictionary["openPrice"] as! Double, decimal: 4).description
        }
        
        if let balanceTemp = (dictionary["highPrice"] as? NSString)?.doubleValue {
            high = "$ " + NumberFormat.init(value: balanceTemp, decimal: 4).description
        } else {
            high = "$ " + NumberFormat.init(value: dictionary["highPrice"] as! Double, decimal: 4).description
        }
        
        if let balanceTemp = (dictionary["lowPrice"] as? NSString)?.doubleValue {
            low = "$ " + NumberFormat.init(value: balanceTemp, decimal: 4).description
        } else {
            low = "$ " + NumberFormat.init(value: dictionary["lowPrice"] as! Double, decimal: 4).description
        }
        
        if let balanceTemp = (dictionary["lastPrice"] as? NSString)?.doubleValue {
            last = "$ " + NumberFormat.init(value: balanceTemp, decimal: 4).description
        } else {
            last = "$ " + NumberFormat.init(value: dictionary["lastPrice"] as! Double, decimal: 4).description
        }
        
        if let balanceTemp = (dictionary["askPrice"] as? NSString)?.doubleValue {
            ask = "$ " + NumberFormat.init(value: balanceTemp, decimal: 4).description
        } else {
            ask = "$ " + NumberFormat.init(value: dictionary["askPrice"] as! Double, decimal: 4).description
        }
        
        if let balanceTemp = (dictionary["bidPrice"] as? NSString)?.doubleValue {
            bid = "$ " + NumberFormat.init(value: balanceTemp, decimal: 4).description
        } else {
            bid = "$ " + NumberFormat.init(value: dictionary["bidPrice"] as! Double, decimal: 4).description
        }
        
    }
   
}
