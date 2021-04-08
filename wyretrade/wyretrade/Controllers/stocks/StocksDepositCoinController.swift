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
    
    var depositFromCoinList = [StocksDepositModel]()
    var usdcBalance = 0.0
    var stocksBalance = 0.0

    @IBOutlet weak var lbStocksBalance: UILabel!
    @IBOutlet weak var lbUSDCBalance: UILabel!
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
            
            var deposit : StocksDepositModel!
            
            if let data = dictionary["stock_transfer"] as? [[String:Any]] {
                
                self.depositFromCoinList = [StocksDepositModel]()
                
                for item in data {
                    deposit = StocksDepositModel(fromDictionary: item)
                    self.depositFromCoinList.append(deposit)
                }
                
                self.historyTable.reloadData()
                

            }
            
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
                let alert = Alert.showBasicAlert(message: error.message)
                        self.presentVC(alert)
            }
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

extension StocksDepositCoinController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return depositFromCoinList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: StocksDepositItem = tableView.dequeueReusableCell(withIdentifier: "StocksDepositItem", for: indexPath) as! StocksDepositItem
        let item = depositFromCoinList[indexPath.row]
        cell.lbRequestAmount.text = item.amount
        cell.lbReceivedAmount.text = item.received
        cell.lbStatus.text = item.status
        cell.lbDate.text = item.date
        
        return cell
    }
}
