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
    var id: String!
    
    init(fromDictionary dictionary: [String: Any]) {
        
        if let balanceTemp = (dictionary["balance"] as? NSString)?.doubleValue {
            balance = NumberFormat.init(value: balanceTemp, decimal: 4).description
        } else {
            balance = NumberFormat.init(value: dictionary["balance"] as! Double, decimal: 4).description
        }
        
        if let amount = (dictionary["amount"] as? NSString)?.doubleValue {
            staking = NumberFormat.init(value: amount, decimal: 4).description
        } else {
            staking = NumberFormat.init(value: dictionary["amount"] as! Double, decimal: 4).description
        }
        
        symbol = dictionary["symbol"] as? String
        icon = dictionary["icon"] as? String
        if !icon.starts(with: "http") {
            icon = Constants.URL.base + icon
        }
        id = "\(dictionary["id"]!)"
    }
    
}
