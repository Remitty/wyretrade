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
        if let payable = dictionary["payable"] as? String {
            received = payable
        }
//        received = dictionary["payable"] as? String
        status = dictionary["status"] as? String
        date = (dictionary["updated_at"] as? String)?.date
        
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
