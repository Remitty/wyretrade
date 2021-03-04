//
//  StakeCoinModel.swift
//  wyretrade
//
//  Created by maxus on 3/3/21.
//

import Foundation

struct StakeCoinModel {
    var balance: String!
    var staking: String!
    var symbol: String!
    var icon: String!
    
    init(fromDictionary dictionary: [String: Any]) {
        balance = dictionary["balance"] as? String
        staking = dictionary["staking"] as? String
        symbol = dictionary["symbol"] as? String
        icon = dictionary["icon"] as? String
        
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary = [String: Any]()
        dictionary["balance"] = balance
        dictionary["staking"] = staking
        dictionary["symbol"] = symbol
        dictionary["icon"] = icon
        
        return dictionary
    }
}
