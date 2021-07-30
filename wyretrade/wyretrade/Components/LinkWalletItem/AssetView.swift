//
//  AssetView.swift
//  wyretrade
//
//  Created by brian on 3/16/21.
//

import Foundation
import UIKit

protocol AssetViewParameterDelegate {
    func depositParamData(param: NSDictionary)
}

class AssetView: UITableViewCell {
    
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbBalance: UILabel!
    @IBOutlet weak var lbFiatValue: UILabel!
    @IBOutlet weak var btnDeposit: UIButton! {
        didSet {
            btnDeposit.round()
        }
    }
    
    var accountId = ""
    var asset = ""
    var delegate: AssetViewParameterDelegate?
    
    @IBAction func actionDeposit(_ sender: Any) {
        let param: NSDictionary = [
            "account_id": accountId,
            "asset": asset
        ]

        self.delegate?.depositParamData(param: param)
    }
}
