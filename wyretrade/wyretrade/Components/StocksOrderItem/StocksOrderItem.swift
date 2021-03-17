//
//  StocksOrderItem.swift
//  wyretrade
//
//  Created by maxus on 3/5/21.
//

import Foundation
import UIKit

protocol StocksOrderItemParameterDelegate {
    func paramData(param: NSDictionary)
}

class StocksOrderItem: UITableViewCell {
    
    @IBOutlet weak var lbTicker: UILabel!
    @IBOutlet weak var lbShares: UILabel!
    @IBOutlet weak var lbType: UILabel!
    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var lbAmount: UILabel!
    @IBOutlet weak var lbDate: UILabel!
}
