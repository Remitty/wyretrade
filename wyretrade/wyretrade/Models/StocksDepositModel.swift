//
//  StocksDepositModel.swift
//  wyretrade
//
//  Created by maxus on 3/4/21.
//

import Foundation

struct StocksDepositModel {
    var amount: String!
    var received: String!
    var status: String!
    var date: String!
    
    
    init(fromDictionary dictionary: [String: Any]) {
        amount = dictionary["amount"] as? String
        received = dictionary["received"] as? String
        status = dictionary["status"] as? String
        date = dictionary["date"] as? String
        
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary = [String: Any]()
        dictionary["amount"] = amount
        dictionary["received"] = received
        dictionary["status"] = status
        dictionary["date"] = date
        
        return dictionary
    }
}
