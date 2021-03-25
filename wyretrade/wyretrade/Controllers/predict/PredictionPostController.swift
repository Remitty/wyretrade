//
//  PredictionPostController.swift
//  wyretrade
//
//  Created by maxus on 3/4/21.
//

import Foundation
import UIKit
import RadioGroup

class PredictionPostController: UIViewController, UITextFieldDelegate {
    
    
    var usdcBalance = ""
    var id = ""
    var asset: PredictAssetModel!
    var duration = 7
    var type = 2
    
    var radioGroup: RadioGroup!

    @IBOutlet weak var lbUSDCBalance: UILabel!
    @IBOutlet weak var lbSymbol: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var viewEst: UIView!
    
    @IBOutlet weak var txtPrice: UITextField! {
        didSet {
            txtPrice.delegate = self
        }
    }
    
    @IBOutlet weak var durationControl: UISegmentedControl!
    
    @IBOutlet weak var txtBetAmount: UITextField! {
        didSet {
            txtBetAmount.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        lbUSDCBalance.text = usdcBalance
        lbSymbol.text = asset.symbol
        lbName.text = asset.name
        lbPrice.text = asset.price
        
        radioGroup = RadioGroup(titles: ["Higher than", "Not changed", "Less than"])
        radioGroup.isVertical = false
        radioGroup.selectedIndex = 0
        radioGroup.addTarget(self, action: #selector(optionSelected), for: .valueChanged)
        viewEst.addSubview(radioGroup)
        radioGroup.translatesAutoresizingMaskIntoConstraints = false
        radioGroup.centerXAnchor.constraint(equalTo: self.viewEst.centerXAnchor).isActive = true
        radioGroup.centerYAnchor.constraint(equalTo: self.viewEst.centerYAnchor).isActive = true
//        radioGroup.widthAnchor.constraint(equalTo: self.viewEst.widthAnchor).isActive = true
//        radioGroup.heightAnchor.constraint(equalTo: self.viewEst.heightAnchor).isActive = true
    }
    
    @objc func optionSelected() {
        print(radioGroup.selectedIndex)
        switch radioGroup.selectedIndex {
        case 0:
            self.type = 2
        case 1:
            self.type = 0
        case 2:
            self.type = 1
        default:
            self.type = 2
        }
    }
    
    func submitPost(param: NSDictionary) {
        RequestHandler.predict(parameter: param as NSDictionary, success: { (successResponse) in
        //                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
                    
            self.showToast(message: "Posted successfully")
        }) { (error) in
            let alert = Alert.showBasicAlert(message: error.message)
                    self.presentVC(alert)
        }
    }
    
    
    @IBAction func durationChanged(_ sender: Any) {
        duration = (durationControl.selectedSegmentIndex + 1) * 7
    }
    
    @IBAction func actionPost(_ sender: Any) {
        guard let price = txtPrice.text else{
            return
        }
        if price == "" {
            txtPrice.shake(6, withDelta: 10, speed: 0.06)
            return
        }
        guard let amount = txtBetAmount.text else{
            return
        }
        if amount == "" {
            txtBetAmount.shake(6, withDelta: 10, speed: 0.06)
            return
        }
        let param: NSDictionary = [
            "est_price": price,
            "bet_price": amount,
            "symbol": id,
            "type": type,
            "duration": duration
        ]
        let alert = Alert.showConfirmAlert(message: "Are you sure creating this prediction?", handler: {
            (_) in self.submitPost(param: param)
        })
        presentVC(alert)
    }
    
    @IBAction func actionPrice25(_ sender: Any) {
        txtBetAmount.text = "25"
    }
    
    @IBAction func actionPrice50(_ sender: Any) {
        txtBetAmount.text = "50"
    }
    
    @IBAction func actionPrice100(_ sender: Any) {
        txtBetAmount.text = "100"
    }
    
    @IBAction func actionPrice200(_ sender: Any) {
        txtBetAmount.text = "200"
    }
}
