//
//  CurrencyModel.swift
//  wyretrade
//
//  Created by brian on 3/15/21.
//

import Foundation

struct CurrencyModel {
    var currency: String!
    var id: Int!
    var symbol: String!
    
    init(fromDictionary dictionary: [String: Any]) {
        currency = dictionary["currency"] as? String
        id = dictionary["id"] as? Int
        symbol = dictionary["symbol"] as? String
    }
}
