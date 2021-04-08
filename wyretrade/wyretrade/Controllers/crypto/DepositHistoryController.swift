//
//  DepositHistoryController.swift
//  wyretrade
//
//  Created by maxus on 3/8/21.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class DepositHistoryController: UIViewController, NVActivityIndicatorViewable {

    @IBOutlet weak var historyTable: UITableView! {
        didSet {
            historyTable.delegate = self
            historyTable.dataSource = self
            historyTable.showsVerticalScrollIndicator = false
            historyTable.separatorColor = UIColor.darkGray
            historyTable.separatorStyle = .singleLineEtched
            historyTable.register(UINib(nibName: "CoinDepositItem", bundle: nil), forCellReuseIdentifier: "CoinDepositItem")
        }
    }
    
    var historyList = [CoinDepositModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
//       self.navigationController?.isNavigationBarHidden = true
       
       self.loadData()
       
    }
    
    func loadData() {
        let param : [String : Any] = [:]
        self.startAnimating()
                RequestHandler.getCoinDepositList(parameter: param as NSDictionary, success: { (successResponse) in
                                self.stopAnimating()
                    let dictionary = successResponse as! [String: Any]
                    
                    var history : CoinDepositModel!
                    
                    if let historyData = dictionary["data"] as? [[String:Any]] {
                        self.historyList = [CoinDepositModel]()
                        for item in historyData {
                            history = CoinDepositModel(fromDictionary: item)
                            self.historyList.append(history)
                        }
                        self.historyTable.reloadData()
                    }
                            
                    
                    
                    }) { (error) in
                        let alert = Alert.showBasicAlert(message: error.message)
                                self.presentVC(alert)
                    }
    }


}
extension DepositHistoryController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CoinDepositItem = tableView.dequeueReusableCell(withIdentifier: "CoinDepositItem", for: indexPath) as! CoinDepositItem
        let item = historyList[indexPath.row]
        cell.imgIcon.load(url: URL(string: item.icon)!)
        cell.lbSymbol.text = item.symbol
        cell.lbAmount.text = item.amount
        cell.lbDate.text = item.date
        
        return cell
    }
}
