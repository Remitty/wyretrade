//
//  NewsView.swift
//  wyretrade
//
//  Created by maxus on 3/2/21.
//

import Foundation
import UIKit

protocol CoinViewParameterDelegate {
    func tradeParamData(param: NSDictionary)
    func depositParamData(param: NSDictionary)
}

class CoinView: UITableViewCell {
    
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbBalance: UILabel!
    @IBOutlet weak var lbHolding: UILabel!
    @IBOutlet weak var lbChangePercent: UILabel!
    @IBOutlet weak var imgChange: UIImageView!
    
    var symbol = ""
    var id = ""
    var delegate: CoinViewParameterDelegate?
    
    @IBAction func actionTrade(_ sender: Any) {
        var param: NSDictionary = [
            "symbol": symbol
        ]
        
        self.delegate?.tradeParamData(param: param)
    }
    
    @IBAction func actionDeposit(_ sender: Any) {
        var param: NSDictionary = [
            "coin": id
        ]
        
        self.delegate?.depositParamData(param: param)
    }
}
