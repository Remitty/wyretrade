//
//  PredictAssetListController.swift
//  wyretrade
//
//  Created by brian on 3/24/21.
//

import Foundation
import UIKit

class PredictAssetListController: UIViewController {
    
    
    @IBOutlet weak var assetTable: UITableView! {
        didSet {
            assetTable.delegate = self
            assetTable.dataSource = self
            assetTable.showsVerticalScrollIndicator = false
            assetTable.separatorColor = UIColor.darkGray
            assetTable.separatorStyle = .singleLineEtched
            assetTable.register(UINib(nibName: "PredictionAssetItem", bundle: nil), forCellReuseIdentifier: "PredictionAssetItem")
        }
    }
    
    var assetList = [PredictAssetModel]()
    var usdcBalance = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

}

extension PredictAssetListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assetList.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        
        let item = assetList[indexPath.row]
        
        let detailController = storyboard?.instantiateViewController(withIdentifier: "PredictionPostController") as! PredictionPostController
        detailController.usdcBalance = self.usdcBalance
//        detailController.asset = item
        detailController.symbol = item.symbol
        detailController.name = item.name
        detailController.price = item.price
        detailController.kind = 0
//        detailController.id = item.id
        
        self.navigationController?.pushViewController(detailController, animated: true)

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PredictionAssetItem = tableView.dequeueReusableCell(withIdentifier: "PredictionAssetItem", for: indexPath) as! PredictionAssetItem
        
        let item = assetList[indexPath.row]
        
        cell.imgIcon.load(url: URL(string: item.icon)!)
        cell.lbChangePercent.text = item.changeToday
        cell.lbName.text = item.name
        cell.lbPrice.text = item.price
        cell.lbSymbol.text = item.symbol
        
        return cell
    }
}
