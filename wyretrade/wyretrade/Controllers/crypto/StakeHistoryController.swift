//
//  StakeHistoryController.swift
//  wyretrade
//
//  Created by brian on 4/8/21.
//

import Foundation
//
//  DepositHistoryController.swift
//  wyretrade
//
//  Created by maxus on 3/8/21.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class StakeHistoryController: UIViewController, NVActivityIndicatorViewable {

    @IBOutlet weak var historyTable: UITableView! {
        didSet {
            historyTable.delegate = self
            historyTable.dataSource = self
            historyTable.showsVerticalScrollIndicator = false
            historyTable.separatorColor = UIColor.darkGray
            historyTable.separatorStyle = .singleLineEtched
            historyTable.register(UINib(nibName: "StakeItem", bundle: nil), forCellReuseIdentifier: "StakeItem")
        }
    }
    
    var historyList = [StakeModel]()
    var coin: String!
    
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
        let param : [String : Any] = ["coin": self.coin!]
        self.startAnimating()
                RequestHandler.getStakeHistory(parameter: param as NSDictionary, success: { (successResponse) in
                                self.stopAnimating()
                    let dictionary = successResponse as! [String: Any]
                    
                    var history : StakeModel!
                    
                    if let historyData = dictionary["history"] as? [[String:Any]] {
                        self.historyList = [StakeModel]()
                        for item in historyData {
                            history = StakeModel(fromDictionary: item)
                            self.historyList.append(history)
                        }
                        self.historyTable.reloadData()
                    }
                            
                    
                    
                    }) { (error) in
                        self.stopAnimating()
                        self.stopAnimating()
                        let alert = Alert.showBasicAlert(message: error.message)
                                self.presentVC(alert)
                    }
    }


}
extension StakeHistoryController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: StakeItem = tableView.dequeueReusableCell(withIdentifier: "StakeItem", for: indexPath) as! StakeItem
        let item = historyList[indexPath.row]
        cell.lbActivity.text = item.type
        cell.lbToken.text = item.token
        cell.lbQty.text = item.qty
        cell.lbDate.text = item.date
        
        return cell
    }
}
