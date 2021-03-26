//
//  CashItemListController.swift
//  wyretrade
//
//  Created by maxus on 3/6/21.
//

import Foundation
import UIKit

class CashItemListController: UIViewController {
    
    @IBOutlet weak var itemTable: UITableView! {
        didSet {
            itemTable.delegate = self
            itemTable.dataSource = self
            itemTable.showsVerticalScrollIndicator = false
            itemTable.separatorColor = UIColor.darkGray
            itemTable.separatorStyle = .singleLineEtched
            itemTable.register(UINib(nibName: "BankContactItem", bundle: nil), forCellReuseIdentifier: "BankContactItem")
        }
    }
    
    var itemList = [BankModel]()
    var currency = ""
    var currencyId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
   
}

extension CashItemListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        
        let item = itemList[indexPath.row]
        
        let detailController = self.storyboard?.instantiateViewController(withIdentifier: "CashSendController") as! CashSendController
//        detailController.itemList = self.itemList
        detailController.currency = currency
        detailController.currencyId = currencyId
        detailController.getter = item
        self.navigationController?.pushViewController(detailController, animated: true)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BankContactItem = tableView.dequeueReusableCell(withIdentifier: "BankContactItem", for: indexPath) as! BankContactItem
        let item = itemList[indexPath.row]
        cell.lbAlias.text = item.alias
        cell.lbCurrency.text = item.currency.currency
        cell.id = item.id
        cell.btnRemove.isHidden = true

        return cell
    }
}

