//
//  TokenTradePair.swift
//  wyretrade
//
//  Created by brian on 3/19/21.
//

import Foundation
struct TokenTradePair {
    var symbol: String!
    var marketSymbol: String!
    var tradeSymbol: String!
    var trade_icon: String!
    var market_icon: String!
    
    init(fromDictionary dictionary: [String: Any]) {
        tradeSymbol = dictionary["trade_symbol"] as? String
        symbol = dictionary["symbol"] as? String
        marketSymbol = dictionary["market_symbol"] as? String
        trade_icon = dictionary["icon1"] as? String
        market_icon = dictionary["icon2"] as? String
    }
}
