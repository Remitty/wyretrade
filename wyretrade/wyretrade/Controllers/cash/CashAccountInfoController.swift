//
//  CashAccountInfoController.swift
//  wyretrade
//
//  Created by maxus on 3/6/21.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class CashAccountInfoController: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet weak var lbEURAccountId: UILabel!
    @IBOutlet weak var lbEURIban: UILabel!
    @IBOutlet weak var lbEURSwift: UILabel!
    
    @IBOutlet weak var lbUsdAccountId: UILabel!
    @IBOutlet weak var lbUsdAccountNumber: UILabel!
    @IBOutlet weak var lbUsdRoutingNumber: UILabel!
    
    @IBOutlet weak var lbGbpAccountId: UILabel!
    @IBOutlet weak var lbGbpAccountNumber: UILabel!
    @IBOutlet weak var lbGbpSortCodet: UILabel!
    
    @IBOutlet weak var btnAssignIban: UIButton!
    
    
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
        let param = [:] as! NSDictionary
        self.startAnimating()
        RequestHandler.getBankDetail(parameter: param , success: { (successResponse) in
                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            var bank : BankModel!
            
            if let data = dictionary["currencies"] as? [[String:Any]] {
                
                for item in data {
                    bank = BankModel(fromDictionary: item)
                    let currency = bank.currency.id
                    switch currency {
                    case 1:
                        self.lbUsdAccountId.text = bank.BankId
                        self.lbUsdAccountNumber.text = bank.usAccountNumber
                        self.lbUsdRoutingNumber.text = bank.usRoutingNumber
                    case 2:
                        self.lbEURAccountId.text = bank.BankId
                        self.lbEURIban.text = bank.Iban
                        self.lbEURSwift.text = bank.Swift
                        if bank.Iban != "" {
                            self.btnAssignIban.isHidden = true
                        }
                    case 3:
                        self.lbGbpAccountId.text = bank.BankId
                        self.lbGbpAccountNumber.text = bank.ukAccountNumber
                        self.lbGbpSortCodet.text = bank.ukSortCode
                    default:
                        print("no bank data")
                    }
                    
                }
                
            }
            
            
        }) { (error) in
                        self.stopAnimating()
            let alert = Alert.showBasicAlert(message: error.message)
                    self.presentVC(alert)
        }
    }

    @IBAction func actionEurAccountIdCopy(_ sender: Any) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = lbEURAccountId.text
        self.showToast(message: "Copied successfully")
    }
    @IBAction func actionEurIbanCopy(_ sender: Any) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = lbEURIban.text
        self.showToast(message: "Copied successfully")
    }
    @IBAction func actionEurSwiftCopy(_ sender: Any) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = lbEURSwift.text
        self.showToast(message: "Copied successfully")
    }
    
    @IBAction func actionUsdAccountIdCopy(_ sender: Any) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = lbUsdAccountId.text
        self.showToast(message: "Copied successfully")
    }
    @IBAction func actionUsdAccountNumberCopy(_ sender: Any) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = lbUsdAccountNumber.text
        self.showToast(message: "Copied successfully")
    }
    @IBAction func actionUsdRoutingNumber(_ sender: Any) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = lbUsdRoutingNumber.text
        self.showToast(message: "Copied successfully")
    }
    
    @IBAction func actionGbpAccountIdCopy(_ sender: Any) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = lbGbpAccountId.text
        self.showToast(message: "Copied successfully")
    }
    @IBAction func actionGbpAccountNumberCopy(_ sender: Any) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = lbGbpAccountNumber.text
        self.showToast(message: "Copied successfully")
    }
    @IBAction func actionGbpSortCopy(_ sender: Any) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = lbGbpSortCodet.text
        self.showToast(message: "Copied successfully")
    }
    
    @IBAction func actionAssignIban(_ sender: Any) {
        let param = [:] as! NSDictionary
        self.startAnimating()
        RequestHandler.addIBAN(parameter: param , success: { (successResponse) in
                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            let success = dictionary["success"] as! Bool
            
            if success {
                let bank = dictionary["bank"] as! BankModel
                self.lbEURIban.text = bank.Iban
                self.lbEURSwift.text = bank.Swift
                if bank.Iban != "" {
                    self.btnAssignIban.isHidden = true
                }
            } else {
                let alert = Alert.showBasicAlert(message: dictionary["message"] as! String)
                        self.presentVC(alert)
            }
            
        }) { (error) in
                        self.stopAnimating()
            let alert = Alert.showBasicAlert(message: error.message)
                    self.presentVC(alert)
        }
    }
    
}
