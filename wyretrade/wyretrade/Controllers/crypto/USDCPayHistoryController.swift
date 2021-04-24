//
//  USDCPayHistoryController.swift
//  wyretrade
//
//  Created by brian on 4/23/21.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class USDCPayHistoryController: UIViewController, NVActivityIndicatorViewable {
    
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
        self.loadHistory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
   
    func loadHistory() {
        self.startAnimating()
        let param : NSDictionary = [:]
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
                    
            
            
            }) { (error) in
                        self.stopAnimating()
                let alert = Alert.showBasicAlert(message: error.message)
                        self.presentVC(alert)
            }
    }
}

extension USDCPayHistoryController: UITableViewDelegate, UITableViewDataSource {
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

