//
//  StocksHistoryController.swift
//  wyretrade
//
//  Created by maxus on 3/5/21.
//

import Foundation
import UIKit
import XLPagerTabStrip

class StocksHistoryController: UIViewController, IndicatorInfoProvider {
    
    var itemInfo: IndicatorInfo = "History"

    @IBOutlet weak var historyTable: UITableView! {
        didSet {
            historyTable.delegate = self
            historyTable.dataSource = self
            historyTable.showsVerticalScrollIndicator = false
            historyTable.separatorColor = UIColor.darkGray
            historyTable.separatorStyle = .singleLineEtched
            historyTable.register(UINib(nibName: "StocksOrderItem", bundle: nil), forCellReuseIdentifier: "StocksOrderItem")
        }
    }
    
    var historyList = [StocksOrderModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    


}

extension StocksHistoryController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 60
        }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: StocksOrderItem = tableView.dequeueReusableCell(withIdentifier: "StocksOrderItem", for: indexPath) as! StocksOrderItem
        let item = historyList[indexPath.row]
        cell.lbTicker.text = item.ticker
        cell.lbShares.text = "\(item.shares!) Shares"
        cell.lbType.text = item.side
        cell.lbStatus.text = item.status
        cell.lbAmount.text = PriceFormat.init(amount: item.amount, currency: Currency.usd).description
        cell.lbDate.text = item.date
        
        return cell
    }
}

