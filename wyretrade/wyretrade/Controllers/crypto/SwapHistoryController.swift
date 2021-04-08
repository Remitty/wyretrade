//
//  SwapHistoryController.swift
//  wyretrade
//
//  Created by brian on 4/4/21.
//

import Foundation
import Foundation
import UIKit
import NVActivityIndicatorView

class SwapHistoryController: UIViewController, NVActivityIndicatorViewable {

    @IBOutlet weak var historyTable: UITableView! {
        didSet {
            historyTable.delegate = self
            historyTable.dataSource = self
            historyTable.showsVerticalScrollIndicator = false
            historyTable.separatorColor = UIColor.darkGray
            historyTable.separatorStyle = .singleLineEtched
            historyTable.register(UINib(nibName: "SwapItem", bundle: nil), forCellReuseIdentifier: "SwapItem")
        }
    }
    
    var historyList = [SwapModel]()
    
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
        self.startAnimating()
        let param : [String : Any] = [:]
                RequestHandler.getCoinExchangeList(parameter: param as NSDictionary, success: { (successResponse) in
                                self.stopAnimating()
                    let dictionary = successResponse as! [String: Any]
                    
                    var history : SwapModel!
                    
                    if let historyData = dictionary["data"] as? [[String:Any]] {
                        self.historyList = [SwapModel]()
                        for item in historyData {
                            history = SwapModel(fromDictionary: item)
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
extension SwapHistoryController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SwapItem = tableView.dequeueReusableCell(withIdentifier: "SwapItem", for: indexPath) as! SwapItem
        let item = historyList[indexPath.row]
        cell.lbSend.text = "\(item.amount!) \(item.sendSymbol!)"
        cell.lbGet.text = "\(item.receiveAmount!) \(item.getSymbol!)"
        cell.lbDate.text = item.date
        cell.lbStatus.text = item.status
        
        return cell
    }
}
