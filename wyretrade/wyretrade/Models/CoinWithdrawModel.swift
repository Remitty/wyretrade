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
        symbol = dictionary["symbol"] as? String
        amount = dictionary["amount"] as? String
        address = dictionary["address"] as? String
        status = dictionary["status"] as? String
        date = dictionary["date"] as? String
        
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary = [String: Any]()
        dictionary["symbol"] = symbol
        dictionary["amount"] = amount
        dictionary["address"] = address
        dictionary["status"] = status
        dictionary["date"] = date
        
        return dictionary
    }
}
