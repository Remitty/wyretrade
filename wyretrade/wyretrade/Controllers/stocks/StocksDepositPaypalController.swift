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
//import PayPalMobile

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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        lbStocksBalance.text = PriceFormat.init(amount: stocksBalance, currency: Currency.usd).description
        
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
    
    func handlePaypal() {
        
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
        
        if !amount.isValid(regex: "/^\\d*\\.?\\d*$/") {
            self.txtAmount.shake(6, withDelta: 10, speed: 0.06)
            return
        }
        
        let defaults = UserDefaults.standard
        
        
        let param = [
            "amount" : amount,
            "type": 3,
            "check_margin": checkMargin
        ] as! NSDictionary
        
        let alert = Alert.showConfirmAlert(message: "Amount: $\(amount) USDC \n Deposit Fee: \(defaults.string(forKey: "stock_deposit_from_card_fee_percent")!)%", handler: {
            (_) in self.submitTransfer(param: param)
        })
        self.presentVC(alert)
    }
}
//
//extension StocksDepositPaypalController: PaypalPaymentDelegate {
//    var environment:String = PayPalEnvironmentNoNetwork {
//           willSet(newEnvironment) {
//               if (newEnvironment != environment) {
//                   PayPalMobile.preconnect(withEnvironment: newEnvironment)
//               }
//           }
//       }
//}
