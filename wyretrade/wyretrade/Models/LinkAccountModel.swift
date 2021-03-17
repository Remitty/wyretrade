//
//  LinkWalletModel.swift
//  wyretrade
//
//  Created by maxus on 3/3/21.
//

import Foundation

struct LinkAccountModel {
    var balance: String!
    var account: String!
    var assetCount: String!
    var id: String!
    
    
    init(fromDictionary dictionary: [String: Any]) {
        if let fiat = (dictionary["balance"] as? NSString)?.doubleValue {
            balance = PriceFormat.init(amount: fiat, currency: Currency.usd).description
        } else {
            balance = PriceFormat.init(amount: dictionary["balance"] as! Double, currency: Currency.usd).description
        }
        
        assetCount = "\(dictionary["asset_cnt"]!)"
        account = dictionary["provider"] as? String
        id = dictionary["account_id"] as? String
        
    }
   
}
