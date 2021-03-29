//
//  StocksOrderController.swift
//  wyretrade
//
//  Created by brian on 3/16/21.
//

import Foundation
import UIKit
import XLPagerTabStrip

class StocksOrderController: UIViewController, IndicatorInfoProvider {
    var itemInfo: IndicatorInfo = "Order"

    @IBOutlet weak var orderTable: UITableView! {
        didSet {
            orderTable.delegate = self
            orderTable.dataSource = self
            orderTable.showsVerticalScrollIndicator = false
            orderTable.separatorColor = UIColor.darkGray
            orderTable.separatorStyle = .singleLineEtched
            orderTable.register(UINib(nibName: "StocksOrderItem", bundle: nil), forCellReuseIdentifier: "StocksOrderItem")
        }
    }
    
    var orderList = [StocksOrderModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
   

}
extension StocksOrderController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        
        let item = orderList[indexPath.row]
        
        let replaceController = storyboard?.instantiateViewController(withIdentifier: "StocksReplaceController") as! StocksReplaceController
        replaceController.order = item
        
        self.navigationController?.pushViewController(replaceController, animated: true)

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 60
        }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: StocksOrderItem = tableView.dequeueReusableCell(withIdentifier: "StocksOrderItem", for: indexPath) as! StocksOrderItem
        let item = orderList[indexPath.row]
        cell.lbTicker.text = item.ticker
        cell.lbShares.text = "\(item.shares!) Shares"
        cell.lbType.text = item.side
        cell.lbStatus.text = item.status
        cell.lbAmount.text = PriceFormat.init(amount: item.amount, currency: Currency.usd).description
        cell.lbDate.text = item.date
        
        return cell
    }
}


