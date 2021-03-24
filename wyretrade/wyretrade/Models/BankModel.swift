//
//  BankModel.swift
//  wyretrade
//
//  Created by brian on 3/15/21.
//

import Foundation

struct BankModel {
    var currency: CurrencyModel!
    var ukAccountNumber: String!
    var ukSortCode: String!
    var Iban: String!
    var Swift: String!
    var usAccountNumber: String!
    var usRoutingNumber: String!
    var BankId: String!
    var balance: Double!
    var type: Int!
    var alias: String!
    var id: String!
    
    init(fromDictionary dictionary: [String: Any]) {
        currency = CurrencyModel(fromDictionary: dictionary["currency"] as! [String: Any]) as? CurrencyModel
        if let data = dictionary["uk_account_number"] as? String {
            ukAccountNumber = data
        }

        if let data = dictionary["uk_sort_code"] as? String {
            ukSortCode = data
        }

        if let data = dictionary["iban"] as? String {
            Iban = data
        }

        if let data = dictionary["bic_swift"] as? String {
            Swift = data
        }

        if let data = dictionary["us_account_number"] as? String {
            usAccountNumber = data
        }

        if let data = dictionary["us_routing_number"] as? String {
            usRoutingNumber = data
        }
        BankId = dictionary["bank_id"] as? String
        
        if let amount = dictionary["balance"] as? NSString {
            balance = amount.doubleValue
        } else {
            balance = dictionary["balance"] as! Double
        }
        
        type = dictionary["type"] as? Int
        alias = dictionary["alias"] as? String
        id = "\(dictionary["id"]!)"
    }
}
