//
//  CardModel.swift
//  wyretrade
//
//  Created by brian on 5/14/21.
//

import Foundation

struct CardModel {
    var cardId: String!
    var lastFour: String!
    var brand: String!
    var cvv: String!
    
    init(fromDictionary dictionary: [String: Any]) {
        cardId = dictionary["card_id"] as? String
        let four = dictionary["last_four"] as? String
        lastFour = "XXXX-XXXX-XXXX-\(four!)"
        brand = dictionary["brand"] as? String
        cvv = dictionary["cvc"] as? String
    }
}
