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
        amount = NumberFormat(value: (dictionary["amount"] as! NSString).doubleValue, decimal: 4).description
        sendSymbol = dictionary["from"] as? String
        getSymbol = dictionary["to"] as? String
        status = dictionary["status_text"] as? String
        date = (dictionary["created_at"] as? String)?.date
        
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
