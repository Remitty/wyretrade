//
//  LinkWalletModel.swift
//  wyretrade
//
//  Created by maxus on 3/3/21.
//

import Foundation

struct LinkWalletModel {
    var holding: String!
    var account: String!
    var assetCount: String!
    
    
    init(fromDictionary dictionary: [String: Any]) {
        holding = dictionary["holding"] as? String
        account = dictionary["account"] as? String
        assetCount = dictionary["assets"] as? String
        
        
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary = [String: Any]()
        dictionary["holding"] = holding
        dictionary["account"] = account
        dictionary["assets"] = assetCount
        
        
        return dictionary
    }
}
