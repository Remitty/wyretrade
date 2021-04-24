//
//  StocksDepositCoinController.swift
//  wyretrade
//
//  Created by maxus on 3/4/21.
//

import Foundation
import UIKit
import XLPagerTabStrip
import NVActivityIndicatorView

class StocksDepositCoinController: UIViewController, IndicatorInfoProvider, UITextFieldDelegate, NVActivityIndicatorViewable {
    
    var itemInfo: IndicatorInfo = "Coin"
    
    
    var usdcBalance = 0.0
    var stocksBalance = 0.0

    @IBOutlet weak var lbStocksBalance: UILabel!
    @IBOutlet weak var lbUSDCBalance: UILabel!
    @IBOutlet weak var txtAmount: UITextField! {
        didSet {
            txtAmount.delegate = self
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        lbStocksBalance.text = PriceFormat.init(amount: stocksBalance, currency: Currency.usd).description
        lbUSDCBalance.text = NumberFormat.init(value: usdcBalance, decimal: 4).description
    }

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    func submitTransfer(param: NSDictionary) {
        self.startAnimating()
        RequestHandler.depositStocks(parameter: param as NSDictionary, success: { (successResponse) in
                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            
            if let usdcBalance = (dictionary["usdc_balance"] as? NSString)?.doubleValue {
                self.usdcBalance = usdcBalance
            } else {
                self.usdcBalance = dictionary["usdc_balance"] as! Double
            }
            
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
    
    @IBAction func actionHistory(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "StocksDepositCoinHistoryController") as! StocksDepositCoinHistoryController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionTransfer(_ sender: Any) {
        guard let amount = txtAmount.text else {
            return
        }
        
        if amount == "" {
            self.txtAmount.shake(6, withDelta: 10, speed: 0.06)
            return
        }
        
        if Double(amount)! > usdcBalance {
            self.showToast(message: "Insufficient funds")
            return
        }
        
        let param = [
            "amount" : amount,
            "type": 0,
            "check_margin": false
        ] as! NSDictionary
        
        let alert = Alert.showConfirmAlert(message: "Are you sure transfer \(amount) USDC ?", handler: {
            (_) in self.submitTransfer(param: param)
        })
        self.presentVC(alert)
    }
}
