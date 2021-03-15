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
    
    init(fromDictionary dictionary: [String: Any]) {
        currency = CurrencyModel(fromDictionary: dictionary["currency"] as! [String: Any]) as? CurrencyModel
        if let data = dictionary["uk_account_number"] as? String {
            ukAccountNumber = data
        }
//        ukAccountNumber = dictionary["ukAccountNumber"] as? String
//        ukSortCode = dictionary["ukSortCode"] as? String
        if let data = dictionary["uk_sort_code"] as? String {
            ukSortCode = data
        }
//        Iban = dictionary["Iban"] as? String
        if let data = dictionary["iban"] as? String {
            Iban = data
        }
//        Swift = dictionary["Swift"] as? String
        if let data = dictionary["bic_swift"] as? String {
            Swift = data
        }
//        usAccountNumber = dictionary["usAccountNumber"] as? String
        if let data = dictionary["us_account_number"] as? String {
            usAccountNumber = data
        }
//        usRoutingNumber = dictionary["usRoutingNumber"] as? String
        if let data = dictionary["us_routing_number"] as? String {
            usRoutingNumber = data
        }
        BankId = dictionary["bank_id"] as? String
    }
}
