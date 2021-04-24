//
//  StocksWithdrawController.swift
//  wyretrade
//
//  Created by maxus on 3/4/21.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class StocksWithdrawController: UIViewController, UITextFieldDelegate, NVActivityIndicatorViewable {

    @IBOutlet weak var txAmount: UITextField!
    @IBOutlet weak var lbBalance: UILabel!
    @IBOutlet weak var lbEstBalance: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        self.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadData()
    }
    
    func loadData() {
        self.startAnimating()
        let param : [String : Any] = [:]
        RequestHandler.withdrawStocksList(parameter: param as NSDictionary, success: { (successResponse) in
                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            
                    
            self.lbBalance.text = NumberFormat.init(value: (dictionary["stock2usdc"] as! NSString).doubleValue, decimal: 4).description
            self.lbEstBalance.text = PriceFormat.init(amount: (dictionary["stock_balance"] as! NSString).doubleValue, currency: Currency.usd).description
            
            }) { (error) in
                        self.stopAnimating()
                let alert = Alert.showBasicAlert(message: error.message)
                        self.presentVC(alert)
            }
    }
    
    func submitWithdraw(amount: String) {
        let param : [String : Any] = [
            "currency": "USDC",
            "amount": amount
        ]
        self.startAnimating()
        RequestHandler.withdrawStocks(parameter: param as NSDictionary, success: { (successResponse) in
                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
           
                    
            self.lbBalance.text = NumberFormat.init(value: (dictionary["usdc_balance"] as! NSString).doubleValue, decimal: 4).description
            self.lbEstBalance.text = PriceFormat.init(amount: (dictionary["stock_balance"] as! NSString).doubleValue, currency: Currency.usd).description
            
            self.showToast(message: dictionary["message"] as! String)
        }) { (error) in
                        self.stopAnimating()
            let alert = Alert.showBasicAlert(message: error.message)
                    self.presentVC(alert)
        }
    }
    
    @IBAction func actionHistory(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "StocksWithdrawHistoryController") as! StocksWithdrawHistoryController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    @IBAction func actionSubmit(_ sender: Any) {
        guard let amount = txAmount.text else {
            return
        }
        if amount == "" {
             self.txAmount.shake(6, withDelta: 10, speed: 0.06)
        }
        else {
           let alert = Alert.showConfirmAlert(message: "Are you sure you want to withdraw \(amount) USDC?", handler: {(_) in
                self.submitWithdraw(amount: amount)
            })
            self.presentVC(alert)
        }
    }
}
