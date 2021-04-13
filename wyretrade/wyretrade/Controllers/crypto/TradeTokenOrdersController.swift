//
//  TradeTokenOrderController.swift
//  wyretrade
//
//  Created by brian on 4/1/21.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class TradeTokenOrdersController: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet weak var orderTable: UITableView! {
        didSet {
            orderTable.delegate = self
            orderTable.dataSource = self
            orderTable.showsVerticalScrollIndicator = false
            orderTable.separatorColor = UIColor.darkGray
            orderTable.separatorStyle = .singleLineEtched
            orderTable.register(UINib(nibName: "TokenOrderItem", bundle: nil), forCellReuseIdentifier: "TokenOrderItem")
            
        }
    }
    
    var orderList = [TokenOrderModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func submitRemove(param: NSDictionary, index: Int) {
        self.startAnimating()
        RequestHandler.coinTradeCancel(parameter: param as NSDictionary, success: { (successResponse) in
                                self.stopAnimating()
        
            self.orderList.remove(at: index)
        
            self.orderTable.reloadData()
        
        
        }) { (error) in
                        self.stopAnimating()
            let alert = Alert.showBasicAlert(message: error.message)
                    self.presentVC(alert)
        }
    }
   
}

extension TradeTokenOrdersController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TokenOrderItem = tableView.dequeueReusableCell(withIdentifier: "TokenOrderItem", for: indexPath) as! TokenOrderItem
        let item = orderList[indexPath.row]
        cell.lbPair.text = item.pair
        cell.lbQty.text = item.qty
        cell.lbPrice.text = item.price
        cell.lbType.text = item.type
        if item.type == "sell" {
            cell.lbType.textColor = .systemRed
        } else {
            cell.lbType.textColor = .systemGreen
        }
        cell.delegate = self
        cell.orderId = item.id
        cell.index = indexPath.row
        return cell
    }
}

extension TradeTokenOrdersController: TokenOrderItemDelegate{
    func removeParam(param: NSDictionary, index: Int) {
        let alert = Alert.showConfirmAlert(message: "Are you sure you want to cancel this order?", handler: {
            (_) in self.submitRemove(param: param, index: index)
        })
        self.presentVC(alert)
    }
    
    
}
