//
//  TokenOrderItem.swift
//  wyretrade
//
//  Created by brian on 3/18/21.
//

import Foundation
import UIKit

protocol TokenOrderItemDelegate {
    func removeParam(param: NSDictionary, index: Int)
}

class TokenOrderItem: UITableViewCell {
    
    @IBOutlet weak var lbType: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbQty: UILabel!
    @IBOutlet weak var lbPair: UILabel!
    
    var delegate: TokenOrderItemDelegate!
    var orderId: String!
    var index: Int!
    
    @IBAction func actionRemove(_ sender: Any) {
        let param: NSDictionary = [
            "orderid": orderId!
        ]
        delegate.removeParam(param: param, index: index)
    }
}
