//
//  SwapRateModel.swift
//  wyretrade
//
//  Created by brian on 4/4/21.
//

import Foundation
struct SwapRateModel {
    var max: String!
    var min: String!
    var rate: Double!
    var fee: Double!
    var sendFee: Double!
    var systemFeePerc: Double!
    
    init(fromDictionary dictionary: [String: Any]) {
        if let depostMax = dictionary["max"] as? NSString {
            max = NumberFormat(value: depostMax.doubleValue, decimal: 3).description
        } else {
            max = NumberFormat(value: dictionary["max"] as! Double, decimal: 3).description
        }
        
        if let depositMin = dictionary["min"] as? NSString {
            min = NumberFormat(value: depositMin.doubleValue, decimal: 3).description
        } else {
            min = NumberFormat(value: dictionary["min"] as! Double, decimal: 3).description
        }
        
        if let instantRate = dictionary["rate"] as? NSString {
            rate = instantRate.doubleValue
        } else {
            rate = dictionary["rate"] as? Double
        }
        
        if let receiveCoinFee = dictionary["receiveFee"] as? NSString {
            fee = receiveCoinFee.doubleValue
        } else {
            fee = dictionary["receiveFee"] as? Double
        }
        
        if let minerFee = dictionary["sendFee"] as? NSString {
            sendFee = minerFee.doubleValue
        } else {
            sendFee = dictionary["sendFee"] as? Double
        }
        
        if let systemFee = dictionary["systemFeePerc"] as? NSString {
            systemFeePerc = systemFee.doubleValue
        } else {
            systemFeePerc = dictionary["systemFeePerc"] as? Double
        }
        
    }
   
}
