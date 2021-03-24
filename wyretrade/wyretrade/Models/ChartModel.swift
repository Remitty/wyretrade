//
//  ChartModel.swift
//  wyretrade
//
//  Created by brian on 3/14/21.
//

import Foundation
struct ChartModel {
    var value: Double!
    var date: String!
    
    init(fromDictionary dictionary: [String: Any]) {
        if let valuetemp = dictionary["open"] as? NSString {
            value = valuetemp.doubleValue
        } else {
            value = dictionary["open"] as? Double
        }
        date = dictionary["date"] as? String        
    }
}
