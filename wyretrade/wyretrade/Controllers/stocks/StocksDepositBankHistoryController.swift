//
//  StocksDepositBankHistoryController.swift
//  wyretrade
//
//  Created by brian on 4/23/21.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class StocksDepositBankHistoryController: UIViewController, NVActivityIndicatorViewable {
    
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
    
    var depositFromBankList = [StocksDepositModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.loadHistory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
   
    func loadHistory() {
        self.startAnimating()
        let param : NSDictionary = [:]
        RequestHandler.getStocksDepositBankHistory(parameter: param as NSDictionary, success: { (successResponse) in
                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            var deposit : StocksDepositModel!
            
            if let data = dictionary["transfer_history"] as? [[String:Any]] {
                
                self.depositFromBankList = [StocksDepositModel]()
                
                for item in data {
                    deposit = StocksDepositModel(fromDictionary: item)
                    self.depositFromBankList.append(deposit)
                }
                
                self.historyTable.reloadData()
                

            }
            
           
            }) { (error) in
                        self.stopAnimating()
                let alert = Alert.showBasicAlert(message: error.message)
                        self.presentVC(alert)
            }
    }
}

extension StocksDepositBankHistoryController: UITableViewDelegate, UITableViewDataSource {
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

