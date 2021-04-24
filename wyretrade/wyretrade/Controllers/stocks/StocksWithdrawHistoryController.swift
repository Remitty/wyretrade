//
//  StocksWithdrawHistoryController.swift
//  wyretrade
//
//  Created by brian on 4/23/21.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class StocksWithdrawHistoryController: UIViewController, NVActivityIndicatorViewable {
    
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
        self.loadHistory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
   
    func loadHistory() {
        self.startAnimating()
        let param : NSDictionary = [:]
        RequestHandler.withdrawStocksList(parameter: param as NSDictionary, success: { (successResponse) in
                        self.stopAnimating()
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
            
           
            }) { (error) in
                        self.stopAnimating()
                let alert = Alert.showBasicAlert(message: error.message)
                        self.presentVC(alert)
            }
    }
}

extension StocksWithdrawHistoryController: UITableViewDelegate, UITableViewDataSource {
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

