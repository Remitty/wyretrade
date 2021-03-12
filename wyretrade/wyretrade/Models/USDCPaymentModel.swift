//
//  USDCPaymentModel.swift
//  wyretrade
//
//  Created by maxus on 3/6/21.
//

import Foundation
struct USDCPaymentModel {
    var to: String!
    var amount: String!
    var date: String!
    var id: String!
    
    
    init(fromDictionary dictionary: [String: Any]) {
        to = dictionary["to"] as? String
        amount = dictionary["amount"] as? String
        date = (dictionary["date"] as? String)?.date
        id = dictionary["id"] as? String
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary = [String: Any]()
        dictionary["to"] = to
        dictionary["amount"] = amount
        dictionary["date"] = date
        dictionary["id"] = id
        
        return dictionary
    }
}
