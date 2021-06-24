//
//  TopStocks.swift
//  wyretrade
//
//  Created by brian on 5/12/21.
//

import Foundation
import UIKit

class TopStocksItem: UICollectionViewCell {
    
    @IBOutlet weak var lbSymbol: UILabel!
    
    @IBOutlet weak var lbPrice: UILabel!
    
    @IBOutlet weak var lbChange: UILabel!
    
    @IBOutlet weak var lbName: UILabel!
    
    var onClick: (() -> ())?
    
    @IBAction func actionClick(_ sender: Any) {
        self.onClick?()
    }
    
}
