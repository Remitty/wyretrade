//
//  MtnModel.swift
//  wyretrade
//
//  Created by maxus on 3/4/21.
//

import Foundation
struct MtnModel {
    var sendSymbol: String!
    var sendAmount: String!
    var getSymbol: String!
    var getAmount: String!
    var status: String!
    var date: String!
    var type: String!
    
    
    init(fromDictionary dictionary: [String: Any]) {
        sendSymbol = dictionary["sendSymbol"] as? String
        sendAmount = dictionary["sendAmount"] as? String
        getSymbol = dictionary["getSymbol"] as? String
        getAmount = dictionary["getAmount"] as? String
        status = dictionary["status"] as? String
        date = dictionary["date"] as? String
        type = dictionary["type"] as? String
        
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary = [String: Any]()
        dictionary["sendSymbol"] = sendSymbol
        dictionary["sendAmount"] = sendAmount
        dictionary["getSymbol"] = getSymbol
        dictionary["getAmount"] = getAmount
        dictionary["status"] = status
        dictionary["date"] = date
        dictionary["type"] = type
        
        return dictionary
    }
}
