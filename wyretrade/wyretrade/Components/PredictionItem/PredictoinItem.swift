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
    var remainingTime = 0
    var timer = Timer()
    
    var cancel: (()->())?
    var bet: (()->())?
    
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbAsset: UILabel!
    @IBOutlet weak var lbContent: UILabel!
    @IBOutlet weak var lbRemainTime: UILabel!
    
    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var lbPayout: UILabel!
    
    @IBOutlet weak var payoutView: UIView!
    
    @IBOutlet weak var cancelView: UIView!
    @IBOutlet weak var lbAnswer: UILabel!
    @IBOutlet weak var betView: UIView!
    
    @IBOutlet weak var btnDisagree: UIButton! {
        didSet {
            btnDisagree.round()
        }
    }
    
    @IBOutlet weak var btnCancel: UIButton! {
        didSet {
            btnCancel.round()
        }
    }
    
    @IBAction func actionBet(_ sender: Any) {
        let param = ["id": self.id] as! NSDictionary
        self.delegate?.betParam(param: param)
    }
    
    @IBAction func actionCancel(_ sender: Any) {
//        let param = ["id": self.id] as! NSDictionary
//        self.delegate?.cancelParam(param: param)
        self.cancel?()
    }
    
    func precessTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(PredictionItem.updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if remainingTime > 0 {
            remainingTime -= 1
            let days = getStringFrom(seconds: (remainingTime / 3600 / 24))
            let hours = getStringFrom(seconds: ((remainingTime / 3600) % 24))
            let minutes = getStringFrom(seconds: ((remainingTime % 3600) / 60))
            let seconds = getStringFrom(seconds: ((remainingTime % 3600) % 60))
            
            lbRemainTime.text="\(days) D \(hours) H \(minutes) M \(seconds) S"
            
        } else {
            timer.invalidate()
        }
    }
    
    func getStringFrom(seconds: Int) -> String {
        
        return seconds < 10 ? "0\(seconds)" : "\(seconds)"
    }
}
