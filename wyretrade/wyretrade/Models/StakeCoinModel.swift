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
    var dbStaking: Double!
    var symbol: String!
    var type: String!
    var icon: String!
    var id: String!
    var rewardYearlyPercent: String!
    var dailyReward: String!
    
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
        
        if let amount = (dictionary["amount"] as? NSString)?.doubleValue {
            dbStaking = amount
        } else {
            dbStaking = dictionary["amount"] as! Double
        }
        
        if let yearly = (dictionary["stake_reward_yearly_percent"] as? NSString)?.doubleValue {
            rewardYearlyPercent = NumberFormat.init(value: yearly, decimal: 4).description
        } else {
            rewardYearlyPercent = NumberFormat.init(value: dictionary["stake_reward_yearly_percent"] as! Double, decimal: 4).description
        }
        
        if let daily = (dictionary["daily_reward"] as? NSString)?.doubleValue {
            dailyReward = NumberFormat.init(value: daily, decimal: 4).description
        } else {
            dailyReward = NumberFormat.init(value: dictionary["daily_reward"] as! Double, decimal: 4).description
        }
        
        symbol = dictionary["symbol"] as? String
        type = dictionary["type"] as? String
        icon = dictionary["icon"] as? String
        if !icon.starts(with: "http") {
            icon = Constants.URL.base + icon
        }
        id = "\(dictionary["id"]!)"
    }
    
}
