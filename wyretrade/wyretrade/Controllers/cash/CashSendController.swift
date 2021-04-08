//
//  CashSendController.swift
//  wyretrade
//
//  Created by maxus on 3/6/21.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class CashSendController: UIViewController, UITextFieldDelegate, NVActivityIndicatorViewable {
    
    var getter: BankModel!
    var currency = ""
    var currencyId = 0
    var rate = 0.0
    var sendingAmount = 0.0
    var gettingAmount = 0.0

    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var txtSendingAmount: UITextField! {
        didSet{
            txtSendingAmount.delegate = self
        }
    }
    @IBOutlet weak var lbSendingCurrency: UILabel!
    @IBOutlet weak var lbGetterCurrency: UILabel!
    @IBOutlet weak var lbGettingAmount: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        lbName.text = getter.alias
        lbSendingCurrency.text = currency
        lbGetterCurrency.text = getter.currency.currency
        
        txtSendingAmount.addTarget(self, action: #selector(CashSendController.amountTextFieldDidChange), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       
        loadRate()
       
    }
    
    @objc func amountTextFieldDidChange(_ textField: UITextField) {
        guard let amount = txtSendingAmount.text else {
            return
        }
        
        if amount == "" {
            lbGettingAmount.text = "0.0"
        }
        
        sendingAmount = Double(amount)!
        
         gettingAmount = rate * sendingAmount
        
        lbGettingAmount.text = "\(gettingAmount)"
        
    }
    
    func loadRate() {
        let param : [String : Any] = [
            "sender_currency": currency,
            "getter_currency": getter.currency.currency!
        ]
        self.startAnimating()
        RequestHandler.getBankCurrencyRate(parameter: param as NSDictionary, success: { (successResponse) in
                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            let success = dictionary["success"] as! Bool
            if success {
                if let rateTemp = dictionary["rate"] as? NSString {
                    self.rate = rateTemp.doubleValue
                } else {
                    self.rate = dictionary["rate"] as! Double
                }
            } else {
                let alert = Alert.showBasicAlert(message: dictionary["error"] as! String)
                self.presentVC(alert)
            }
            
            
        }) { (error) in
                        self.stopAnimating()
            let alert = Alert.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
    func submitSend() {
        let param : [String : Any] = [
            "send_currency": currencyId,
            "getter_id": getter.id!,
            "amount": sendingAmount,
            "type": getter.type
        ]
        self.startAnimating()
        RequestHandler.sendBankMoney(parameter: param as NSDictionary, success: { (successResponse) in
                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            self.showToast(message: dictionary["message"] as! String)
            
            }) { (error) in
                        self.stopAnimating()
                let alert = Alert.showBasicAlert(message: error.message)
                        self.presentVC(alert)
            }
    }
    
    
    @IBAction func actionSend(_ sender: Any) {
        if sendingAmount == 0 {
            txtSendingAmount.shake(6, withDelta: 10, speed: 0.06)
            return
        }
        
        let alert = Alert.showConfirmAlert(message: "Are you sure sending \(sendingAmount)\(currency) to \(getter.alias) ?", handler: {
            (_) in self.submitSend()
        })
        
        self.presentVC(alert)
    }
    

}
