//
//  OHLCModel.swift
//  wyretrade
//
//  Created by brian on 6/21/21.
//

import Foundation

struct OHLCModel {
    var open: Double!
    var high: Double!
    var low: Double!
    var close: Double!
    var date: String!
    
    init(fromDictionary dictionary: [Any]) {
        
        date = String(dictionary[0] as! Double)
        open = dictionary[1] as? Double
        high = dictionary[2] as? Double
        low = dictionary[3] as? Double
        close = dictionary[4] as? Double
    }
}
