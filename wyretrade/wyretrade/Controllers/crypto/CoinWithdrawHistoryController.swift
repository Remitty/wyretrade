//
//  CoinWithdrawHistoryController.swift
//  wyretrade
//
//  Created by brian on 4/23/21.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class CoinWithdrawHistoryController: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet weak var historyTable: UITableView! {
        didSet {
                    historyTable.delegate = self
                    historyTable.dataSource = self
                    historyTable.showsVerticalScrollIndicator = false
                    historyTable.separatorColor = UIColor.darkGray
                    historyTable.separatorStyle = .singleLineEtched
                    historyTable.register(UINib(nibName: "CoinWithdrawItem", bundle: nil), forCellReuseIdentifier: "CoinWithdrawItem")
                }
    }
    
    var historyList = [CoinWithdrawModel]()
    
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
        RequestHandler.getCoinWithdrawList(parameter: param as NSDictionary, success: { (successResponse) in
                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            var history : CoinWithdrawModel!
            
            if let historyData = dictionary["history"] as? [[String:Any]] {
                self.historyList = [CoinWithdrawModel]()
                for item in historyData {
                    history = CoinWithdrawModel(fromDictionary: item)
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

extension CoinWithdrawHistoryController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CoinWithdrawItem = tableView.dequeueReusableCell(withIdentifier: "CoinWithdrawItem", for: indexPath) as! CoinWithdrawItem
        let item = historyList[indexPath.row]
        cell.lbAsset.text = item.symbol
        cell.lbAmount.text = item.amount
        cell.lbStatus.text = item.status
        cell.lbDate.text = item.date
        cell.lbAddress.text = item.address

        return cell
    }
}

