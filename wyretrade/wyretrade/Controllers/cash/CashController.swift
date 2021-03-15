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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let tap5 = UITapGestureRecognizer(target: self, action: #selector(CashController.bankClick))
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
    
    @objc func accountClick(sender: UITapGestureRecognizer) {
        let accountVC = self.storyboard?.instantiateViewController(withIdentifier: "CashAccountInfoController") as! CashAccountInfoController
        self.navigationController?.pushViewController(accountVC, animated: true)
    }
    
    @objc func addClick(sender: UITapGestureRecognizer) {
        
    }
    
    @objc func sendClick(sender: UITapGestureRecognizer) {
        
    }
    
    @objc func bankClick(sender: UITapGestureRecognizer) {
        
    }
    
    @objc func contactClick(sender: UITapGestureRecognizer) {
        
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
