//
//  CompanyModel.swift
//  wyretrade
//
//  Created by brian on 3/14/21.
//

import Foundation
struct CompanyModel {
    var description: String!
    var industry: String!
    var site: String!
    var ceo: String!
    
    init(fromDictionary dictionary: [String: Any]) {
        description = dictionary["description"] as? String
        industry = dictionary["industry"] as? String
        site = dictionary["website"] as? String
        ceo = dictionary["ceo"] as? String
    }
}
