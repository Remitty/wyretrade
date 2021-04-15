//
//  MtnTransactionController.swift
//  wyretrade
//
//  Created by maxus on 3/4/21.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class MtnTransactionController: UIViewController, NVActivityIndicatorViewable {

    @IBOutlet weak var historyTable: UITableView! {
        didSet {
                    historyTable.delegate = self
                    historyTable.dataSource = self
                    historyTable.showsVerticalScrollIndicator = false
                    historyTable.separatorColor = UIColor.darkGray
                    historyTable.separatorStyle = .singleLineEtched
                    historyTable.register(UINib(nibName: "MtnItem", bundle: nil), forCellReuseIdentifier: "MtnItem")
                }
    }
    
    var historyList = [MtnModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        self.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       self.navigationController?.isNavigationBarHidden = true
        self.loadData()
   }

   override func viewWillDisappear(_ animated: Bool) {
       super.viewWillDisappear(animated)
       self.navigationController?.isNavigationBarHidden = false
   }
    
    func loadData() {
        self.startAnimating()
            let param : [String : Any] = [:]
            RequestHandler.getMtnTransactions(parameter: param as NSDictionary, success: { (successResponse) in
                            self.stopAnimating()
                let dictionary = successResponse as! [String: Any]
                
                var history : MtnModel!
                
                if let historyData = dictionary["transactions"] as? [[String:Any]] {
                    self.historyList = [MtnModel]()
                    for item in historyData {
                        history = MtnModel(fromDictionary: item)
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

extension MtnTransactionController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyList.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MtnItem = tableView.dequeueReusableCell(withIdentifier: "MtnItem", for: indexPath) as! MtnItem
        let item = historyList[indexPath.row]
        cell.lbToPhone.text = item.toPhone
        cell.lbAmount.text = item.amount+"XAF"
        cell.lbStatus.text = item.status
        cell.lbDate.text = item.date
        cell.lbType.text = item.type
        


        return cell
    }
}
