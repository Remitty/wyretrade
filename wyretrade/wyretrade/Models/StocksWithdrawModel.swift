//
//  StocksWithdrawModel.swift
//  wyretrade
//
//  Created by brian on 3/14/21.
//

import Foundation
struct StocksWithdrawModel {
    var request: Double!
    var received: Double!
    var status: String!
    var date: String!
    
    init(fromDictionary dictionary: [String: Any]) {
        request = dictionary["req_amount"] as? Double
        received = dictionary["payable_amount"] as? Double
        date = (dictionary["created_at"] as? String)?.date
        status = dictionary["status"] as? String
    }
}
