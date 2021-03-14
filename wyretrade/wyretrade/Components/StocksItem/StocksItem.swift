//
//  StocksItem.swift
//  wyretrade
//
//  Created by maxus on 3/4/21.
//

import Foundation
import UIKit

protocol StocksItemParameterDelegate {
    func paramData(param: NSDictionary)
}

class StocksItem: UITableViewCell {
    
    @IBOutlet weak var lbStocksSymbol: UILabel!
    @IBOutlet weak var lbStocksPrice: UILabel!
    @IBOutlet weak var lbStocksShares: UILabel!
    @IBOutlet weak var lbStocksChangePercent: UILabel!
    @IBOutlet weak var lbStocksName: UILabel!
}
