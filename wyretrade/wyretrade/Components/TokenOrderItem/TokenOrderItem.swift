//
//  TokenOrderItem.swift
//  wyretrade
//
//  Created by brian on 3/18/21.
//

import Foundation
import UIKit

class TokenOrderItem: UITableViewCell {
    
    @IBOutlet weak var lbType: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbQty: UILabel!
    @IBOutlet weak var lbPair: UILabel!
    
    @IBAction func actionRemove(_ sender: Any) {
    }
}
