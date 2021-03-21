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
    @IBOutlet weak var btnBuy: UIButton!
    
    var symbol = ""
    var id = ""
    var buyType = 0
    var delegate: CoinViewParameterDelegate?
    
    @IBAction func actionTrade(_ sender: Any) {
        let param: NSDictionary = [
            "coin": id,
            "symbol": symbol,
            "buyType": buyType
        ]
        
        self.delegate?.tradeParamData(param: param)
    }
    
    @IBAction func actionDeposit(_ sender: Any) {
        let param: NSDictionary = [
            "coin": id,
            "symbol": symbol
        ]
        
        self.delegate?.depositParamData(param: param)
    }
}
