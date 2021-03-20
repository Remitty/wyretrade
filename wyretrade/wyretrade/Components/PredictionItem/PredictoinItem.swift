//
//  PredictoinItem.swift
//  wyretrade
//
//  Created by maxus on 3/4/21.
//

import Foundation
import UIKit

protocol PredictionItemParameterDelegate {
    func betParam(param: NSDictionary)
    func cancelParam(param: NSDictionary)
}

class PredictionItem: UITableViewCell {
    
    var delegate: PredictionItemParameterDelegate!
    var id: String!
    
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbAsset: UILabel!
    @IBOutlet weak var lbContent: UILabel!
    @IBOutlet weak var lbRemainTime: UILabel!
    
    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var lbPayout: UILabel!
    
    @IBOutlet weak var answerView: UIView!
    @IBOutlet weak var lbAnswer: UILabel!
    @IBOutlet weak var betView: UIView!
    
    @IBAction func actionBet(_ sender: Any) {
        let param = ["id": self.id] as! NSDictionary
        self.delegate?.betParam(param: param)
    }
    
    @IBAction func actionCancel(_ sender: Any) {
        let param = ["id": self.id] as! NSDictionary
        self.delegate?.cancelParam(param: param)
    }
}
