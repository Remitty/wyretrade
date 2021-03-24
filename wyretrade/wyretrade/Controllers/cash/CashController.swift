//
//  CashController.swift
//  wyretrade
//
//  Created by maxus on 3/1/21.
//

import UIKit

class CashController: UIViewController {
    
    @IBOutlet weak var accountView: UIView!
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var sendView: UIView!
    @IBOutlet weak var bankView: UIView!
    @IBOutlet weak var contactView: UIView!
    @IBOutlet weak var historyTable: UITableView!
    
    var historyLis = [CashTransactionModel]()
    var bankList = [BankModel]()
    var itemList = [BankModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addLeftBarButtonWithImage(UIImage(named: "ic_menu")!)
        
        historyTable.isHidden = true
        
        // Do any additional setup after loading the view.
        accountView.isUserInteractionEnabled = true
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(CashController.accountClick))
        accountView.addGestureRecognizer(tap1)
        
        addView.isUserInteractionEnabled = true
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(CashController.addClick))
        addView.addGestureRecognizer(tap2)
        
        sendView.isUserInteractionEnabled = true
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(CashController.sendClick))
        sendView.addGestureRecognizer(tap3)
        
        bankView.isUserInteractionEnabled = true
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(CashController.bankClick))
        bankView.addGestureRecognizer(tap4)
        
        contactView.isUserInteractionEnabled = true
        let tap5 = UITapGestureRecognizer(target: self, action: #selector(CashController.contactClick))
        contactView.addGestureRecognizer(tap5)
        
//        self.loadData()
    }
    
    func loadData() {
        let param = [:] as! NSDictionary
        
        RequestHandler.getBankDetail(parameter: param , success: { (successResponse) in
//                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any] 
            
        }) { (error) in
            let alert = Alert.showBasicAlert(message: error.message)
                    self.presentVC(alert)
        }
    }
    
    func submitAdd(param: NSDictionary) {
        RequestHandler.addBank(parameter: param , success: { (successResponse) in
//                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            self.showToast(message: "Added successfully")
            
            var bank : BankModel!
                        
            if let bankData = dictionary["currencies"] as? [[String:Any]] {
                self.bankList = [BankModel]()
                for item in bankData {
                    bank = BankModel(fromDictionary: item)
                    self.bankList.append(bank)
                }
                self.historyTable.reloadData()
            }
        }) { (error) in
            let alert = Alert.showBasicAlert(message: error.message)
                    self.presentVC(alert)
        }
    }
    
    func confirmAdd(param: NSDictionary) {
        let alert = Alert.showConfirmAlert(message: "Are you sure adding \(param["currency"]!) ?", handler: {
            (_) in self.submitAdd(param: param)
        })
        self.presentVC(alert)
    }
    
    @objc func accountClick(sender: UITapGestureRecognizer) {
        let accountVC = self.storyboard?.instantiateViewController(withIdentifier: "CashAccountInfoController") as! CashAccountInfoController
        self.navigationController?.pushViewController(accountVC, animated: true)
    }
    
    @objc func addClick(sender: UITapGestureRecognizer) {
        let alertController = UIAlertController(title: "Select currency", message: "", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "USD", style: .default) { (_) in
            self.confirmAdd(param: ["currency": "USD"])
        }
        let action2 = UIAlertAction(title: "EUR", style: .default) { action in
            self.confirmAdd(param: ["currency": "EUR"])
        }
        let action3 = UIAlertAction(title: "GBP", style: .default) { action in
            self.confirmAdd(param: ["currency": "GBP"])
        }
        let action4 = UIAlertAction(title: "SGD", style: .default) { action in
            self.confirmAdd(param: ["currency": "SGD"])
        }
        
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(action3)
        alertController.addAction(action4)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        self.presentVC(alertController);
    }
    
    @objc func sendClick(sender: UITapGestureRecognizer) {
        let param: NSDictionary = [:]
        RequestHandler.getBankFriendList(parameter: param as NSDictionary, success: { (successResponse) in
        //                        self.stopAnimating()
        let dictionary = successResponse as! [String: Any]
        
        var bank : BankModel!
        
        if let historyData = dictionary["data"] as? [[String:Any]] {
            self.itemList = [BankModel]()
            for item in historyData {
                bank = BankModel(fromDictionary: item)
                self.itemList.append(bank)
                
            }
            let detailController = self.storyboard?.instantiateViewController(withIdentifier: "CashItemListController") as! CashItemListController
            detailController.itemList = self.itemList
            self.navigationController?.pushViewController(detailController, animated: true)
        }
                
            
        
        }) { (error) in
            let alert = Alert.showBasicAlert(message: error.message)
                    self.presentVC(alert)
        }
    }
    
    @objc func bankClick(sender: UITapGestureRecognizer) {
        let param: NSDictionary = [:]
        RequestHandler.getBankFriendList(parameter: param as NSDictionary, success: { (successResponse) in
        //                        self.stopAnimating()
        let dictionary = successResponse as! [String: Any]
        
        var bank : BankModel!
        
        if let historyData = dictionary["data"] as? [[String:Any]] {
            self.itemList = [BankModel]()
            for item in historyData {
                bank = BankModel(fromDictionary: item)
                if bank.type == 1 {
                    self.itemList.append(bank)
                }
                
            }
            let detailController = self.storyboard?.instantiateViewController(withIdentifier: "CashBankController") as! CashBankController
            detailController.itemList = self.itemList
            self.navigationController?.pushViewController(detailController, animated: true)
        }
                
            
        
        }) { (error) in
            let alert = Alert.showBasicAlert(message: error.message)
                    self.presentVC(alert)
        }
    }
    
    @objc func contactClick(sender: UITapGestureRecognizer) {
        let param: NSDictionary = [:]
        RequestHandler.getBankFriendList(parameter: param as NSDictionary, success: { (successResponse) in
        //                        self.stopAnimating()
        let dictionary = successResponse as! [String: Any]
        
        var bank : BankModel!
        
        if let Data = dictionary["data"] as? [[String:Any]] {
            
            self.itemList = [BankModel]()
            for item in Data {
                bank = BankModel(fromDictionary: item)
                
                if bank.type! == 2 {
                    self.itemList.append(bank)
                }
                
            }
            let detailController = self.storyboard?.instantiateViewController(withIdentifier: "CashContactController") as! CashContactController
            detailController.itemList = self.itemList
            self.navigationController?.pushViewController(detailController, animated: true)
        }
                
            
        
        }) { (error) in
            let alert = Alert.showBasicAlert(message: error.message)
                    self.presentVC(alert)
        }
    }

}

//extension CashController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return historyList.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell: StocksWithdrawItem = tableView.dequeueReusableCell(withIdentifier: "StocksWithdrawItem", for: indexPath) as! StocksWithdrawItem
//        let item = historyList[indexPath.row]
//        cell.lbRequestAmount.text = "\(item.request!)"
//        cell.lbReceivedAmount.text = "\(item.received!)"
//        cell.lbStatus.text = item.status
//        cell.lbDate.text = item.date
//
//
//        return cell
//    }
//}
