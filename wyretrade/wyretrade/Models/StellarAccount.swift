//
//  StellarAccount.swift
//  wyretrade
//
//  Created by brian on 4/8/21.
//

import Foundation

struct StellarAccount {
    var accountId: String!
    var secret: String!
    
    init(fromDictionary dictionary: [String: Any]) {
        
        accountId = dictionary["accountId"] as? String
        secret = dictionary["secret"] as? String
    }
}
