//
//  USDCSendingController.swift
//  wyretrade
//
//  Created by maxus on 3/6/21.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class USDCPayController: UIViewController, UITextFieldDelegate, NVActivityIndicatorViewable {

    @IBOutlet weak var balance: UILabel!
    @IBOutlet weak var txtAmount: UITextField! {
        didSet {
            txtAmount.delegate = self
        }
    }
    @IBOutlet weak var txtUser: UITextField! {
        didSet {
            txtUser.delegate = self
        }
    }
    @IBOutlet weak var historyTable: UITableView! {
        didSet {
            historyTable.delegate = self
            historyTable.dataSource = self
            historyTable.showsVerticalScrollIndicator = false
            historyTable.separatorColor = UIColor.darkGray
            historyTable.separatorStyle = .singleLineEtched
            historyTable.register(UINib(nibName: "USDCPayment", bundle: nil), forCellReuseIdentifier: "USDCPayment")
        }
    }
    
    var historyList = [USDCPaymentModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        self.loadTransaction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadTransaction()
    }
    
    func loadTransaction() {
        self.startAnimating()
        let param : [String : Any] = [:]
        RequestHandler.coinTransferList(parameter: param as NSDictionary, success: { (successResponse) in
                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            var history : USDCPaymentModel!
            
            if let historyData = dictionary["pay_history"] as? [[String:Any]] {
                self.historyList = [USDCPaymentModel]()
                for item in historyData {
                    history = USDCPaymentModel(fromDictionary: item)
                    self.historyList.append(history)
                }
                self.historyTable.reloadData()
            }
                    
            self.balance.text = NumberFormat.init(value: dictionary["usdc_balance"] as! Double, decimal: 4).description
            
            }) { (error) in
                        self.stopAnimating()
                let alert = Alert.showBasicAlert(message: error.message)
                        self.presentVC(alert)
            }
    }
    
    func pay(param: NSDictionary) {
        self.startAnimating()
        RequestHandler.coinTransferAddContact(parameter: param, success: {(successResponse) in
            self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            var history : USDCPaymentModel!
            
            if let historyData = dictionary["pay_history"] as? [[String:Any]] {
                self.historyList = [USDCPaymentModel]()
                for item in historyData {
                    history = USDCPaymentModel(fromDictionary: item)
                    self.historyList.append(history)
                }
                self.historyTable.reloadData()
            }
            
            self.balance.text = NumberFormat.init(value: dictionary["usdc_balance"] as! Double, decimal: 4).description
        
        }) {
            (error) in
                        self.stopAnimating()
            let alert = Alert.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    

    @IBAction func actionSubmit(_ sender: Any) {
        guard let amount = txtAmount.text else {
                    return
                }
        guard let name = txtUser.text else {
            return
        }
        if amount == "" {
            self.txtAmount.shake(6, withDelta: 10, speed: 0.06)
        }
        
        else if name == "" {
             self.txtUser.shake(6, withDelta: 10, speed: 0.06)
        } else {
            let param: NSDictionary = [
                "amount" : amount,
                "user": name,
            ]
            
            self.pay(param: param)
        }
        
    }
}

extension USDCPayController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: USDCPayment = tableView.dequeueReusableCell(withIdentifier: "USDCPayment", for: indexPath) as! USDCPayment
        let item = historyList[indexPath.row]
        cell.to.text = item.to
        cell.amount.text = item.amount
        cell.date.text = item.date
        
        return cell
    }
}
