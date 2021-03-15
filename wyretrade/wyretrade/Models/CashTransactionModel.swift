//
//  CashTransactionModel.swift
//  wyretrade
//
//  Created by brian on 3/15/21.
//

import Foundation
struct CashTransactionModel {
    var currency: String!
    var amount: String!
    var type: String!
    var status: String!
    
    init(fromDictionary dictionary: [String: Any]) {
        currency = dictionary["currency"] as? String
        amount = dictionary["amount"] as? String
        type = dictionary["type"] as? String
        status = dictionary["status"] as? String
    }
}
