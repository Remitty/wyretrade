//
//  CoinDepositModel.swift
//  wyretrade
//
//  Created by brian on 3/16/21.
//

import Foundation

struct CoinDepositModel {
    var icon: String!
    var symbol: String!
    var amount: String!
    var date: String!
    
    init(fromDictionary dictionary: [String: Any]) {
        symbol = dictionary["currency"] as? String
        icon = dictionary["icon"] as? String
        if !icon.starts(with: "http") {
            icon = Constants.URL.base + icon
        }
        amount = dictionary["amount"] as? String
        date = (dictionary["updated_at"] as! String).date
    }
}
