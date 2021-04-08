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
    
    
    @IBOutlet weak var lbUSDBalance: UILabel!
    @IBOutlet weak var lbStocksBalance: UILabel!
    @IBOutlet weak var txtAmount: UITextField! {
        didSet {
            txtAmount.delegate = self
        }
    }
    @IBOutlet weak var historyTable: UITableView! {
        didSet {
            historyTable.delegate = self
            historyTable.dataSource = self
            historyTable.showsVerticalScrollIndicator = false
            historyTable.separatorColor = UIColor.darkGray
            historyTable.separatorStyle = .singleLineEtched
            historyTable.register(UINib(nibName: "StocksDepositItem", bundle: nil), forCellReuseIdentifier: "StocksDepositItem")
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
            
            var deposit : StocksDepositModel!
            
            if let data = dictionary["stock_transfer"] as? [[String:Any]] {
                
                self.depositFromBankList = [StocksDepositModel]()
                
                for item in data {
                    deposit = StocksDepositModel(fromDictionary: item)
                    self.depositFromBankList.append(deposit)
                }
                self.historyTable.reloadData()
            }
            
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
            "check_margin": false
        ] as! NSDictionary
        
        let alert = Alert.showConfirmAlert(message: "Are you sure transfer $\(amount) ?", handler: {
            (_) in self.submitTransfer(param: param)
        })
        self.presentVC(alert)
    }
}


extension StocksDepositBankController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return depositFromBankList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: StocksDepositItem = tableView.dequeueReusableCell(withIdentifier: "StocksDepositItem", for: indexPath) as! StocksDepositItem
        let item = depositFromBankList[indexPath.row]
        cell.lbRequestAmount.text = item.amount
        cell.lbReceivedAmount.text = item.received
        cell.lbStatus.text = item.status
        cell.lbDate.text = item.date
        
        return cell
    }
}
