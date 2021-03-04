//
//  SwapModel.swift
//  wyretrade
//
//  Created by maxus on 3/3/21.
//

import Foundation

struct SwapModel {
    var amount: String!
    var sendSymbol: String!
    var getSymbol: String!
    var status: String!
    var date: String!
    
    
    init(fromDictionary dictionary: [String: Any]) {
        amount = dictionary["amount"] as? String
        sendSymbol = dictionary["sendSymbol"] as? String
        getSymbol = dictionary["getSymbol"] as? String
        status = dictionary["status"] as? String
        date = dictionary["date"] as? String
        
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary = [String: Any]()
        dictionary["amount"] = amount
        dictionary["sendSymbol"] = sendSymbol
        dictionary["getSymbol"] = getSymbol
        dictionary["status"] = status
        dictionary["date"] = date
        
        return dictionary
    }
}
