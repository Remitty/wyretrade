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
    
    init(fromDictionary dictionary: [String: Any]) {
        if let depostMax = dictionary["depositMax"] as? NSString {
            max = NumberFormat(value: depostMax.doubleValue, decimal: 3).description
        } else {
            max = NumberFormat(value: dictionary["depositMax"] as! Double, decimal: 3).description
        }
        
        if let depositMin = dictionary["depositMin"] as? NSString {
            min = NumberFormat(value: depositMin.doubleValue, decimal: 3).description
        } else {
            min = NumberFormat(value: dictionary["depositMin"] as! Double, decimal: 3).description
        }
        
        if let instantRate = dictionary["instantRate"] as? NSString {
            rate = instantRate.doubleValue
        } else {
            rate = dictionary["instantRate"] as? Double
        }
        
        if let receiveCoinFee = dictionary["receiveCoinFee"] as? NSString {
            fee = receiveCoinFee.doubleValue
        } else {
            fee = dictionary["receiveCoinFee"] as? Double
        }
        
    }
   
}
