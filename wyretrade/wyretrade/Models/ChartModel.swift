//
//  ChartModel.swift
//  wyretrade
//
//  Created by brian on 3/14/21.
//

import Foundation
struct ChartModel {
    var value: String!
    var date: String!
    
    init(fromDictionary dictionary: [String: Any]) {
        value = dictionary["value"] as? String
        date = dictionary["date"] as? String        
    }
}
