//
//  StocksWithdrawController.swift
//  wyretrade
//
//  Created by maxus on 3/4/21.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import LinkKit


class StocksWithdrawController: UIViewController, UITextFieldDelegate, NVActivityIndicatorViewable {

    @IBOutlet weak var txAmount: UITextField!
    @IBOutlet weak var lbBalance: UILabel!
    @IBOutlet weak var lbEstBalance: UILabel!
    
    @IBOutlet weak var btnUSDC: UIButton! {
        didSet {
            btnUSDC.roundCorners()
        }
    }

    @IBOutlet weak var btnPaypal: UIButton! {
        didSet {
            btnPaypal.roundCorners()
        }
    }
    
    @IBOutlet weak var btnBank: UIButton! {
        didSet {
            btnBank.roundCorners()
        }
    }

    @IBOutlet weak var btnCard: UIButton! {
        didSet {
            btnCard.roundCorners()
        }
    }
    
    @IBOutlet weak var btnCards: UIButton! {
        didSet {
            btnCards.round()
        }
    }

    @IBOutlet weak var btnHistory: UIButton! {
        didSet {
            btnHistory.round()
        }
    }
    @IBOutlet weak var btnConnect: UIButton! {
        didSet {
            btnConnect.round()
        }
    }

    
    
    var stocksBalance = 0.0
    var estUsdc = 0.0
    var paypal: String!
    var withdrawFee = 0.0
    var coinWithdrawFee = 0.0
    var bank: String!
    var stripeAccountVerified = false
    var type: String!
    var selectedCard: String!
    var handler: Handler!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        self.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadData()
        self.getOpenLink()
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
            self.bank = dictionary["stripe_bank"] as? String
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
        if !amount.isValid(regex: "/^\\d*\\.?\\d*$/") {
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
    
    func openPlaid() {
        let method: PresentationMethod = .viewController(self)
        
        self.handler.open(presentUsing: method)
    }
    
    func connectPlaid(linkToken: String) {
        let configuration = LinkTokenConfiguration(
            token: linkToken,
            onSuccess: { linkSuccess in
                // Send the linkSuccess.publicToken to your app server.
                
                self.sendPlaid(pubToken: linkSuccess.publicToken, accountId: linkSuccess.metadata.accounts[0].id)
            }
        )
        
        let result = Plaid.create(configuration)
        
        switch result {
          case .failure(let error):
            let alert = Alert.showBasicAlert(message: "Unable to create Plaid handler due to: \(error)")
            self.presentVC(alert)
          case .success(let handler):
              self.handler = handler
            
        }
    }
    
    func getOpenLink() {
        let param : [String: Any] = [:]
        self.startAnimating()
        RequestHandler.getPlaidToken(parameter: param as NSDictionary, success: { (successResponse) in
                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            self.connectPlaid(linkToken: dictionary["link_token"] as! String)
            
            
            
        }) { (error) in
                        self.stopAnimating()
            let alert = Alert.showBasicAlert(message: error.message)
                    self.presentVC(alert)
        }
    }
    
    func sendPlaid(pubToken: String, accountId: String) {
        let param : [String: Any] = [
            "pub_token": pubToken,
            "account_id": accountId
        ]
        self.startAnimating()
        RequestHandler.connectPlaidBank(parameter: param as NSDictionary, success: { (successResponse) in
                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
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
                openPlaid()
            } else {
                let alert = Alert.showConfirmAlert(message: "No connected account. Would you connect?", handler: {
                                                    (_) in self.createStripeConnectLink(create: true)}
                )
                self.presentVC(alert)
            }
        } else {
            let alert = Alert.showConfirmAlert(message: "Connected to \(bank!) already. Would you replace with other bank?", handler: {
                                                (_) in }
            )
            self.presentVC(alert)
        }
    }
    
    
}
