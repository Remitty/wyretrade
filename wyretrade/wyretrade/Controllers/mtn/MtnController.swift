//
//  MtnController.swift
//  wyretrade
//
//  Created by maxus on 3/4/21.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class MtnController: UIViewController, NVActivityIndicatorViewable {

    @IBOutlet weak var transactionView: UIView!
    @IBOutlet weak var lbBalance: UILabel!
    @IBOutlet weak var lbCurrency: UILabel!
    
    @IBOutlet weak var btnWithdraw: UIButton! {
        didSet {
            btnWithdraw.round()
        }
    }

    @IBOutlet weak var btnTopup: UIButton! {
        didSet {
            btnTopup.round()
        }
    }
    
    @IBOutlet weak var btnToUSDC: UIButton! {
        didSet {
            btnToUSDC.round()
        }
    }

    @IBOutlet weak var btnToMtn: UIButton! {
        didSet {
            btnToMtn.round()
        }
    }
    
    var balance = 0.0
    var historyList = [MtnModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //        self.addLeftBarButtonWithImage(UIImage(named: "ic_menu")!)
//        self.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
//       self.navigationController?.isNavigationBarHidden = true
        self.loadData()
   }
//
//   override func viewWillDisappear(_ animated: Bool) {
//       super.viewWillDisappear(animated)
//       self.navigationController?.isNavigationBarHidden = false
//   }
    
    func loadData() {
        self.startAnimating()
        let param : [String : Any] = [:]
                RequestHandler.getMtnService(parameter: param as NSDictionary, success: { (successResponse) in
                                self.stopAnimating()
                    let dictionary = successResponse as! [String: Any]
                    
                    var history : MtnModel!
                    
                    if let historyData = dictionary["history"] as? [[String:Any]] {
                        self.historyList = [MtnModel]()
                        for item in historyData {
                            history = MtnModel(fromDictionary: item)
                            self.historyList.append(history)
                        }
                        
                    }
                            
                    if let balance = (dictionary["balance"] as? NSString)?.doubleValue {
                        self.lbBalance.text = NumberFormat.init(value: balance, decimal: 4).description
                        self.balance = balance
                    } else {
                        self.balance = dictionary["balance"] as! Double
                        self.lbBalance.text = NumberFormat.init(value: dictionary["balance"] as! Double, decimal: 4).description
                    }
                    self.lbCurrency.text = dictionary["currency"] as! String
                    
                    var item = MtnModel(fromDictionary: dictionary["transaction"] as! [String: Any]) as! MtnModel
                    let cell = Bundle.main.loadNibNamed("MtnItem", owner: self, options: nil)?[0] as! MtnItem
                    cell.lbToPhone.text = item.toPhone
                    cell.lbAmount.text = item.amount+"XAF"
                    cell.lbStatus.text = item.status
                    cell.lbDate.text = item.date
                    cell.lbType.text = item.type
                    self.transactionView.addSubview(cell)
                    cell.translatesAutoresizingMaskIntoConstraints = false
                    cell.centerXAnchor.constraint(equalTo: self.transactionView.centerXAnchor).isActive = true
                    cell.centerYAnchor.constraint(equalTo: self.transactionView.centerYAnchor).isActive = true
                    cell.widthAnchor.constraint(equalTo: self.transactionView.widthAnchor).isActive = true
                    cell.heightAnchor.constraint(equalTo: self.transactionView.heightAnchor).isActive = true
                    
                    }) { (error) in
                        self.stopAnimating()
                        let alert = Alert.showBasicAlert(message: error.message)
                                self.presentVC(alert)
                    }
    }
    
    func submitWithdraw(param: NSDictionary) {
        self.startAnimating()
        RequestHandler.payMtn(parameter: param as NSDictionary, success: { (successResponse) in
                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            var history : MtnModel!
            
            if let historyData = dictionary["history"] as? [[String:Any]] {
                self.historyList = [MtnModel]()
                for item in historyData {
                    history = MtnModel(fromDictionary: item)
                    self.historyList.append(history)
                }
                
            }
                    
            self.lbBalance.text = NumberFormat.init(value: (dictionary["balance"] as! NSString).doubleValue, decimal: 2).description
            if let balance = (dictionary["balance"] as? NSString)?.doubleValue {
                self.lbBalance.text = NumberFormat.init(value: balance, decimal: 4).description
                self.balance = balance
            } else {
                self.balance = dictionary["change"] as! Double
                self.lbBalance.text = NumberFormat.init(value: dictionary["change"] as! Double, decimal: 4).description
            }
            self.lbCurrency.text = dictionary["currency"] as! String
            
            }) { (error) in
                        self.stopAnimating()
                let alert = Alert.showBasicAlert(message: error.message)
                        self.presentVC(alert)
            }
    }
    
    func submitCollection(param: NSDictionary) {
        self.startAnimating()
        RequestHandler.topupMtn(parameter: param as NSDictionary, success: { (successResponse) in
                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            var history : MtnModel!
            
            if let historyData = dictionary["history"] as? [[String:Any]] {
                self.historyList = [MtnModel]()
                for item in historyData {
                    history = MtnModel(fromDictionary: item)
                    self.historyList.append(history)
                }
                
            }
                    
            self.lbBalance.text = NumberFormat.init(value: (dictionary["balance"] as! NSString).doubleValue, decimal: 2).description
            if let balance = (dictionary["balance"] as? NSString)?.doubleValue {
                self.lbBalance.text = NumberFormat.init(value: balance, decimal: 4).description
                self.balance = balance
            } else {
                self.balance = dictionary["change"] as! Double
                self.lbBalance.text = NumberFormat.init(value: dictionary["change"] as! Double, decimal: 4).description
            }
            self.lbCurrency.text = dictionary["currency"] as! String
            
            }) { (error) in
                        self.stopAnimating()
                let alert = Alert.showBasicAlert(message: error.message)
                        self.presentVC(alert)
            }
    }
    
    func submitConvert(param: NSDictionary) {
        self.startAnimating()
        RequestHandler.convertMtn(parameter: param as NSDictionary, success: { (successResponse) in
                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            var history : MtnModel!
            
            if let historyData = dictionary["history"] as? [[String:Any]] {
                self.historyList = [MtnModel]()
                for item in historyData {
                    history = MtnModel(fromDictionary: item)
                    self.historyList.append(history)
                }
                
            }
                    
            self.lbBalance.text = NumberFormat.init(value: (dictionary["balance"] as! NSString).doubleValue, decimal: 2).description
            if let balance = (dictionary["balance"] as? NSString)?.doubleValue {
                self.lbBalance.text = NumberFormat.init(value: balance, decimal: 4).description
                self.balance = balance
            } else {
                self.balance = dictionary["change"] as! Double
                self.lbBalance.text = NumberFormat.init(value: dictionary["change"] as! Double, decimal: 4).description
            }
            self.lbCurrency.text = dictionary["currency"] as! String
            
            }) { (error) in
                        self.stopAnimating()
                let alert = Alert.showBasicAlert(message: error.message)
                        self.presentVC(alert)
            }
    }

    @IBAction func actionDisbursement(_ sender: Any) {
        let alertController = UIAlertController(title: "Disbursement", message: nil, preferredStyle: .alert)
        let copyAction = UIAlertAction(title: "Ok", style: .default) { (_) in
            let textField1 = alertController.textFields?.first as! UITextField
            let text1 = textField1.text
            if text1 == "" {
                textField1.shake(6, withDelta: 10, speed: 0.06)
                return
            }
            let textField2 = alertController.textFields?[1] as! UITextField
            let text2 = textField2.text
            if text2 == "" {
                textField2.shake(6, withDelta: 10, speed: 0.06)
                return
            }
            let param = [
                "amount": text1,
                "to": text2
            ] as! NSDictionary
            self.submitWithdraw(param: param)
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Amount"
            textField.keyboardType = UIKeyboardType.decimalPad
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Phone number"
            textField.keyboardType = UIKeyboardType.phonePad
        }
        alertController.addAction(copyAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func actionTopup(_ sender: Any) {
        let alertController = UIAlertController(title: "Collection", message: nil, preferredStyle: .alert)
        let copyAction = UIAlertAction(title: "Ok", style: .default) { (_) in
            let textField1 = alertController.textFields?.first as! UITextField
            let text1 = textField1.text
            if text1 == "" {
                textField1.shake(6, withDelta: 10, speed: 0.06)
                return
            }
            let textField2 = alertController.textFields?[1] as! UITextField
            let text2 = textField2.text
            if text2 == "" {
                textField2.shake(6, withDelta: 10, speed: 0.06)
                return
            }
            let param = [
                "amount": text1,
                "to": text2
            ] as! NSDictionary
            self.submitCollection(param: param)
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Amount"
            textField.keyboardType = UIKeyboardType.decimalPad
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Phone number"
            textField.keyboardType = UIKeyboardType.phonePad
        }
        alertController.addAction(copyAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func actionMtnToUsdc(_ sender: Any) {
        let alertController = UIAlertController(title: "Convert", message: nil, preferredStyle: .alert)
        let copyAction = UIAlertAction(title: "Ok", style: .default) { (_) in
            let textField = alertController.textFields?.first as! UITextField
            let text = textField.text
            if text == "" {
                textField.shake(6, withDelta: 10, speed: 0.06)
                return
            }
            let param = [
                "amount": text,
                "type": 1
            ] as! NSDictionary
            self.submitConvert(param: param)
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Amount"
            textField.keyboardType = UIKeyboardType.decimalPad
        }
       
        alertController.addAction(copyAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func actionUsdcToMtn(_ sender: Any) {
        let alertController = UIAlertController(title: "Convert", message: nil, preferredStyle: .alert)
        let copyAction = UIAlertAction(title: "Ok", style: .default) { (_) in
            let textField = alertController.textFields?.first as! UITextField
            let text = textField.text
            if text == "" {
                textField.shake(6, withDelta: 10, speed: 0.06)
                return
            }
            let param = [
                "amount": text,
                "type": 1
            ] as! NSDictionary
            self.submitConvert(param: param)
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Amount"
            textField.keyboardType = UIKeyboardType.decimalPad
        }
       
        alertController.addAction(copyAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}
