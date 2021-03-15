//
//  StocksWithdrawController.swift
//  wyretrade
//
//  Created by maxus on 3/4/21.
//

import Foundation
import UIKit

class StocksWithdrawController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txAmount: UITextField!
    @IBOutlet weak var lbBalance: UILabel!
    @IBOutlet weak var lbEstBalance: UILabel!
    
    @IBOutlet weak var historyTable: UITableView! {
        didSet {
            historyTable.delegate = self
            historyTable.dataSource = self
            historyTable.showsVerticalScrollIndicator = false
            historyTable.separatorColor = UIColor.darkGray
            historyTable.separatorStyle = .singleLineEtched
            historyTable.register(UINib(nibName: "StocksWithdrawItem", bundle: nil), forCellReuseIdentifier: "StocksWithdrawItem")
        }
    }
    
    var historyList = [StocksWithdrawModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.loadData()
    }
    
    func loadData() {
        let param : [String : Any] = [:]
        RequestHandler.withdrawStocksList(parameter: param as NSDictionary, success: { (successResponse) in
//                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            var history : StocksWithdrawModel!
            
            if let historyData = dictionary["history"] as? [[String:Any]] {
                self.historyList = [StocksWithdrawModel]()
                for item in historyData {
                    history = StocksWithdrawModel(fromDictionary: item)
                    self.historyList.append(history)
                }
                self.historyTable.reloadData()
            }
                    
            self.lbBalance.text = NumberFormat.init(value: (dictionary["stock2usdc"] as! NSString).doubleValue, decimal: 4).description
            self.lbEstBalance.text = PriceFormat.init(amount: (dictionary["stock_balance"] as! NSString).doubleValue, currency: Currency.usd).description
            
            }) { (error) in
                let alert = Alert.showBasicAlert(message: error.message)
                        self.presentVC(alert)
            }
    }
    
    func submitWithdraw(amount: String) {
        let param : [String : Any] = [
            "currency": "USDC",
            "amount": amount
        ]
        RequestHandler.withdrawStocks(parameter: param as NSDictionary, success: { (successResponse) in
//                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            var history : StocksWithdrawModel!
            
            if let historyData = dictionary["history"] as? [[String:Any]] {
                self.historyList = [StocksWithdrawModel]()
                for item in historyData {
                    history = StocksWithdrawModel(fromDictionary: item)
                    self.historyList.append(history)
                }
                self.historyTable.reloadData()
            }
                    
            self.lbBalance.text = NumberFormat.init(value: (dictionary["usdc_balance"] as! NSString).doubleValue, decimal: 4).description
            self.lbEstBalance.text = PriceFormat.init(amount: (dictionary["stock_balance"] as! NSString).doubleValue, currency: Currency.usd).description
            
            self.showToast(message: dictionary["message"] as! String)
        }) { (error) in
            let alert = Alert.showBasicAlert(message: error.message)
                    self.presentVC(alert)
        }
    }

    @IBAction func actionSubmit(_ sender: Any) {
        guard let amount = txAmount.text else {
            return
        }
        if amount == "" {
             self.txAmount.shake(6, withDelta: 10, speed: 0.06)
        }
        else {
           let alert = Alert.showConfirmAlert(message: "Are you sure you want to withdraw \(amount) USDC?", handler: {(_) in
                self.submitWithdraw(amount: amount)
            })
            self.presentVC(alert)
        }
    }
}

extension StocksWithdrawController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: StocksWithdrawItem = tableView.dequeueReusableCell(withIdentifier: "StocksWithdrawItem", for: indexPath) as! StocksWithdrawItem
        let item = historyList[indexPath.row]
        cell.lbRequestAmount.text = "\(item.request!)"
        cell.lbReceivedAmount.text = "\(item.received!)"
        cell.lbStatus.text = item.status
        cell.lbDate.text = item.date
        
        
        return cell
    }
}
