//
//  SwapModel.swift
//  wyretrade
//
//  Created by maxus on 3/3/21.
//

import Foundation

struct SwapModel {
    var amount: String!
    var receiveAmount: String!
    var sendSymbol: String!
    var getSymbol: String!
    var status: String!
    var date: String!
    
    
    init(fromDictionary dictionary: [String: Any]) {
        amount = NumberFormat(value: (dictionary["amount"] as! NSString).doubleValue, decimal: 4).description
        if let receive = dictionary["received"] as? NSString {
            receiveAmount = NumberFormat(value: receive.doubleValue, decimal: 4).description
        } else {
            receiveAmount = NumberFormat(value: dictionary["received"] as! Double, decimal: 4).description
        }
//        receiveAmount = NumberFormat(value: (dictionary["received"] as! NSString).doubleValue, decimal: 4).description
        sendSymbol = dictionary["from"] as? String
        getSymbol = dictionary["to"] as? String
        status = dictionary["status_text"] as? String
        date = (dictionary["created_at"] as? String)?.date
        
    }
   
}
