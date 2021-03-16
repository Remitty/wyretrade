//
//  CoinWithdrawModel.swift
//  wyretrade
//
//  Created by maxus on 3/5/21.
//

import Foundation

struct CoinWithdrawModel {
    var symbol: String!
    var amount: String!
    var address: String!
    var status: String!
    var date: String!
    
    
    init(fromDictionary dictionary: [String: Any]) {
        symbol = dictionary["currency"] as? String
        amount = "\(dictionary["amount"]!)"
        address = dictionary["address"] as? String
        status = dictionary["status_text"] as? String
        date = (dictionary["created_at"] as! String).date
        
    }
    
}
