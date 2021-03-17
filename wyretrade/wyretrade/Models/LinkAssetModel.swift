//
//  LinkAssetModel.swift
//  wyretrade
//
//  Created by brian on 3/16/21.
//

import Foundation

struct LinkAssetModel {
    var name: String!
    var icon: String!
    var balance: String!
    var fiatValue: String!
    var symbol: String!
    
    
    init(fromDictionary dictionary: [String: Any]) {
        symbol = dictionary["currency"] as? String
        icon = dictionary["logo"] as? String
        
        if let balanceTemp = (dictionary["balance"] as? NSString)?.doubleValue {
            balance = NumberFormat.init(value: balanceTemp, decimal: 4).description
        } else {
            balance = NumberFormat.init(value: dictionary["balance"] as! Double, decimal: 4).description
        }
        
        if let fiat = (dictionary["fiat_value"] as? NSString)?.doubleValue {
            fiatValue = PriceFormat.init(amount: fiat, currency: Currency.usd).description
        } else {
            fiatValue = PriceFormat.init(amount: dictionary["fiat_value"] as! Double, currency: Currency.usd).description
        }
        name = dictionary["name"] as? String
        
    }
   
}
