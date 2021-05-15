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
    
    
    var stocksBalance = 0.0
    var estUsdc = 0.0
    var paypal: String!
    var withdrawFee = 0.0
    var coinWithdrawFee = 0.0
    var bank: String!
    var stripeAccountVerified = false
    var type: String!
    var selectedCard: String!
    
    
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
            
            self.stocksBalance = (dictionary["stock_balance"] as! NSString).doubleValue
            self.estUsdc = (dictionary["stock2usdc"] as! NSString).doubleValue
                    
            self.lbBalance.text = NumberFormat.init(value: self.estUsdc, decimal: 4).description
            self.lbEstBalance.text = PriceFormat.init(amount: self.stocksBalance, currency: Currency.usd).description
            self.paypal = dictionary["paypal"] as? String
            self.bank = dictionary["bank"] as? String
            self.withdrawFee = (dictionary["withdraw_fee"] as! NSString).doubleValue
            self.coinWithdrawFee = (dictionary["coinwithdraw_fee"] as! NSString).doubleValue
            self.stripeAccountVerified = (dictionary["stripe_account_verified"] as! Int) == 0 ? false : true
            
            }) { (error) in
                        self.stopAnimating()
                let alert = Alert.showBasicAlert(message: error.message)
                        self.presentVC(alert)
            }
    }
    
    func submitWithdraw(amount: String) {
        let param : [String : Any] = [
            "type": self.type!,
            "amount": amount,
            "paypal": self.paypal!,
            "card_id": self.selectedCard!
        ]
        self.startAnimating()
        RequestHandler.withdrawStocks(parameter: param as NSDictionary, success: { (successResponse) in
                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            self.stocksBalance = (dictionary["stock_balance"] as! NSString).doubleValue
            self.estUsdc = (dictionary["stock2usdc"] as! NSString).doubleValue
                    
            self.lbBalance.text = NumberFormat.init(value: self.estUsdc, decimal: 4).description
            self.lbEstBalance.text = PriceFormat.init(amount: self.stocksBalance, currency: Currency.usd).description
            
            self.showToast(message: dictionary["message"] as! String)
        }) { (error) in
                        self.stopAnimating()
            let alert = Alert.showBasicAlert(message: error.message)
                    self.presentVC(alert)
        }
    }
    
    func createStripeConnectLink(create: Bool) {
        let param : [String: Any] = [:]
        self.startAnimating()
        RequestHandler.stripeConnect(parameter: param as NSDictionary, success: { (successResponse) in
                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            self.stripeAccountVerified = (dictionary["stripe_account_verified"] as! Int) == 0 ? false : true
            
            if self.stripeAccountVerified {
                let alert = Alert.showBasicAlert(message: dictionary["message"] as! String)
                self.presentVC(alert)
            } else {
                if create {
                    let webviewController = self.storyboard?.instantiateViewController(withIdentifier: "webVC") as! webVC
                    webviewController.url = dictionary["stripe_connect_link"] as! String
                    self.navigationController?.pushViewController(webviewController, animated: true)
                } else {
                    let alert = Alert.showBasicAlert(message: "Not connected")
                    self.presentVC(alert)
                }
            }
            
            
            
        }) { (error) in
                        self.stopAnimating()
            let alert = Alert.showBasicAlert(message: error.message)
                    self.presentVC(alert)
        }
    }
    
    func checkValidate() -> Bool {
        guard let amount = txAmount.text else {
            return false
        }
        if amount.isValid(regex: "/^\\d*\\.?\\d*$/") {
             self.txAmount.shake(6, withDelta: 10, speed: 0.06)
            return false
        }
        if self.type == "USDC" {
            if Double(amount)! > self.estUsdc {
                let alert = Alert.showBasicAlert(message: "Insufficient USDC balance")
                self.presentVC(alert)
                return false
            }
        } else {
            if Double(amount)! > self.stocksBalance {
                let alert = Alert.showBasicAlert(message: "Insufficient stocks balance")
                self.presentVC(alert)
                return false
            }
        }
        
        
        return true
    }
    
    @IBAction func actionHistory(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "StocksWithdrawHistoryController") as! StocksWithdrawHistoryController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    @IBAction func actionSubmit(_ sender: Any) {
        
        self.type = "USDC"
        
        let validate = self.checkValidate()
        
        if !validate {
            return
        }
        let amount = self.txAmount.text!
        let alert = Alert.showConfirmAlert(message: "Payout amount: \(amount) USDC?", handler: {(_) in
            self.submitWithdraw(amount: amount)
        })
        self.presentVC(alert)
        
    }
    
    @IBAction func actionWithdrawToPaypal(_ sender: UIButton) {
        self.type = "paypal"
        
        let validate = self.checkValidate()
        
        if !validate {
            return
        }
        let amount = self.txAmount.text!
        let alert = Alert.showConfirmAlert(message: "Payout amount: \(amount) USDC? \n Withdraw fee: $\(self.withdrawFee)", handler: {(_) in
            self.submitWithdraw(amount: amount)
        })
        self.presentVC(alert)
        
    }
    
    @IBAction func actionWithdrawToBank(_ sender: UIButton) {
        self.type = "bank"
        
        let validate = self.checkValidate()
        
        if !validate {
            return
        }
        let amount = self.txAmount.text!
        let alert = Alert.showConfirmAlert(message: "Payout amount: \(amount) USDC? \n Withdraw fee: $\(self.withdrawFee)", handler: {(_) in
            self.submitWithdraw(amount: amount)
        })
        self.presentVC(alert)
    }
    
    @IBAction func actionWithdrawToCard(_ sender: UIButton) {
        
    }
    
    @IBAction func actionCards(_ sender: Any) {
        if stripeAccountVerified {
            let vc = storyboard?.instantiateViewController(withIdentifier: "CardController") as! CardController
            vc.withdrawal = 1
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let alert = Alert.showConfirmAlert(message: "No connected account. Would you connect?", handler: {
                                                (_) in self.createStripeConnectLink(create: true)}
            )
            self.presentVC(alert)
        }
    }
    
    @IBAction func actionConnectBank(_ sender: UIButton) {
        if bank.isEmpty {
            if stripeAccountVerified {
                //Plaid
            } else {
                let alert = Alert.showConfirmAlert(message: "No connected account. Would you connect?", handler: {
                                                    (_) in self.createStripeConnectLink(create: true)}
                )
                self.presentVC(alert)
            }
        } else {
            let alert = Alert.showConfirmAlert(message: "Connected to \(bank) already. Would you replace with other bank?", handler: {
                                                (_) in }
            )
            self.presentVC(alert)
        }
    }
    
    
}
