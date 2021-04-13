//
//  TradeCryptoHistoryController.swift
//  wyretrade
//
//  Created by brian on 3/18/21.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class TradeTokenHistoryController: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet weak var historyTable: UITableView!{
        didSet {
            historyTable.delegate = self
            historyTable.dataSource = self
            historyTable.showsVerticalScrollIndicator = false
            historyTable.separatorColor = UIColor.darkGray
            historyTable.separatorStyle = .singleLineEtched
            historyTable.register(UINib(nibName: "TokenHistoryItem", bundle: nil), forCellReuseIdentifier: "TokenHistoryItem")
        }
    }
    
    var historyList = [TokenOrderModel]()
    var pair = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadData()
    }
    
    func loadData() {
        let param : [String : Any] = ["pair": self.pair]
        self.startAnimating()
                RequestHandler.coinTradeHistory(parameter: param as NSDictionary, success: { (successResponse) in
                                self.stopAnimating()
                    let dictionary = successResponse as! [String: Any]
                    
                    var history : TokenOrderModel!
                    
                    if let historyData = dictionary["history"] as? [[String:Any]] {
                        self.historyList = [TokenOrderModel]()
                        for item in historyData {
                            history = TokenOrderModel(fromDictionary: item)
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

extension TradeTokenHistoryController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TokenHistoryItem = tableView.dequeueReusableCell(withIdentifier: "TokenHistoryItem", for: indexPath) as! TokenHistoryItem
        let item = historyList[indexPath.row]
        cell.lbDate.text = item.date
        cell.lbPrice.text = item.price
        cell.lbQty.text = item.qty
        cell.lbType.text = item.type
        if item.type == "sell" {
            cell.lbType.textColor = .systemRed
        } else {
            cell.lbType.textColor = .systemGreen
        }
        return cell
    }
}
