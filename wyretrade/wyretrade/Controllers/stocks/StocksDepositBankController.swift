//
//  StocksDepositBankController.swift
//  wyretrade
//
//  Created by maxus on 3/4/21.
//

import Foundation
import UIKit
import XLPagerTabStrip
import NVActivityIndicatorView

class StocksDepositBankController: UIViewController, IndicatorInfoProvider, UITextFieldDelegate, NVActivityIndicatorViewable {

    var itemInfo: IndicatorInfo = "Bank"
    
    var depositFromBankList = [StocksDepositModel]()
    var usdBalance = ""
    var dbUSDBalance = 0.0
    var stocksBalance = 0.0
    var checkMargin = false
    
    
    @IBOutlet weak var lbUSDBalance: UILabel!
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
        if usdBalance != "No wallet" {
            dbUSDBalance = (usdBalance as! NSString).doubleValue
            usdBalance = "$\(dbUSDBalance)"
        }
        
        lbUSDBalance.text = usdBalance
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
            
            
            
            self.usdBalance = dictionary["usd_balance"] as! String
            
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
        let vc = storyboard?.instantiateViewController(withIdentifier: "StocksDepositBankHistoryController") as! StocksDepositBankHistoryController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    @IBAction func actionSubmit(_ sender: Any) {
        guard let amount = txtAmount.text else {
            return
        }
        
        if amount == "" {
            self.txtAmount.shake(6, withDelta: 10, speed: 0.06)
            return
        }
        
        if Double(amount)! > dbUSDBalance {
            self.showToast(message: "Insufficient funds")
            return
        }
        
        let param = [
            "amount" : amount,
            "type": 1,
            "check_margin": checkMargin
        ] as! NSDictionary
        
        let alert = Alert.showConfirmAlert(message: "Are you sure transfer $\(amount) ?", handler: {
            (_) in self.submitTransfer(param: param)
        })
        self.presentVC(alert)
    }
}

