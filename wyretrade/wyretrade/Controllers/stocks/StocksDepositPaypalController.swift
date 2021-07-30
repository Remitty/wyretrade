//
//  StocksDepositPaypalController.swift
//  wyretrade
//
//  Created by maxus on 3/4/21.
//

import Foundation
import UIKit
import XLPagerTabStrip
import NVActivityIndicatorView
import PayPalCheckout

class StocksDepositPaypalController: UIViewController, IndicatorInfoProvider, UITextFieldDelegate, NVActivityIndicatorViewable {
    
    var itemInfo: IndicatorInfo = "Paypal"

    var stocksBalance = 0.0
    var checkMargin = false
    var paypal: [String: Any]!

    @IBOutlet weak var lbStocksBalance: UILabel!
    
    @IBOutlet weak var txtAmount: UITextField! {
        didSet {
            txtAmount.delegate = self
        }
    }
    @IBOutlet weak var btnMarginCheck: UIButton!
    
    @IBOutlet weak var btnTransfer: UIButton! {
        didSet {
            btnTransfer.round()
        }
    }

    @IBOutlet weak var btnHistory: UIButton! {
        didSet {
            btnHistory.round()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        lbStocksBalance.text = PriceFormat.init(amount: stocksBalance, currency: Currency.usd).description
//        print(paypal["client_id"] as! String)
//        let config = CheckoutConfig(
//                clientID: paypal["client_id"] as! String,
//                returnUrl: "https://wyretrade.com",
//            environment: .sandbox
//            )
//
//            Checkout.set(config: config)
        
    }

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    func submitTransfer(param: NSDictionary) {
        self.startAnimating()
        RequestHandler.depositStocks(parameter: param as NSDictionary, success: { (successResponse) in
                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
           
            
            if let stockBalance = (dictionary["stock_balance"] as? NSString)?.doubleValue {
                self.stocksBalance = stockBalance
            } else {
                self.stocksBalance = dictionary["stock_balance"] as! Double
            }
   
            }) { (error) in
                        self.stopAnimating()
                let alert = Alert.showBasicAlert(message: error.message)
                        self.presentVC(alert)
            }
    }
    
    func showMarginFeeAlert() {
        let defaults = UserDefaults.init()
        let alert = Alert.showBasicAlert(message: defaults.string(forKey: "msgMarginAccountUsagePolicy")!)
        self.presentVC(alert)
    }
    
    func handlePaypal(param: NSDictionary) {
        Checkout.start(
                createOrder: { createOrderAction in

                    let amount = PurchaseUnit.Amount(currencyCode: .usd, value: "10.00")
                    let purchaseUnit = PurchaseUnit(amount: amount)
                    let order = OrderRequest(intent: .capture, purchaseUnits: [purchaseUnit])

                    createOrderAction.create(order: order)

                }, onApprove: { approval in

                    approval.actions.capture { (response, error) in
                        print("Order successfully captured: \(response?.data)")
                        self.submitTransfer(param:param)
                    }

                }, onCancel: {

                    // Optionally use this closure to respond to the user canceling the paysheet

                }, onError: { error in

                    // Optionally use this closure to respond to the user experiencing an error in
                    // the payment experience
                    print(error.error)
                    print(error.reason)
                }
            )
    }
    
    @IBAction func actionCheckMargin(_ sender: Any) {
        if checkMargin {
            checkMargin = false
            btnMarginCheck.setImage(UIImage(systemName: "squareshape"), for: .normal)
        } else {
            checkMargin = true
            btnMarginCheck.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            showMarginFeeAlert()
        }
    }
    
    
    @IBAction func actionHistory(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "StocksDepositCoinHistoryController") as! StocksDepositCoinHistoryController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionTransfer(_ sender: Any) {
        guard let amount = txtAmount.text else {
            return
        }
        
//        if !amount.isValid(regex: "/^\\d*\\.?\\d*$/") {
//            self.txtAmount.shake(6, withDelta: 10, speed: 0.06)
//            return
//        }
        
        if amount.isEmpty || amount == "." {
            self.txtAmount.shake(6, withDelta: 10, speed: 0.06)
            return
        }
        
        if Double(amount)! == 0 {
            self.txtAmount.shake(6, withDelta: 10, speed: 0.06)
            return
        }
        
        let defaults = UserDefaults.standard
        
        
        let param = [
            "amount" : amount,
            "type": 3,
            "check_margin": checkMargin
        ] as! NSDictionary
        
        let alert = Alert.showConfirmAlert(message: "Amount: $\(amount) \n Deposit Fee: \(defaults.string(forKey: "stock_deposit_from_card_fee_percent")!)%", handler: {
            (_) in self.handlePaypal(param: param)
        })
        self.presentVC(alert)
    }
}

