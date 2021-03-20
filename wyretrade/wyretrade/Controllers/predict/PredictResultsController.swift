//
//  PredictResultsController.swift
//  wyretrade
//
//  Created by maxus on 3/4/21.
//

import Foundation
import UIKit
import XLPagerTabStrip

class PredictResultsController: UIViewController, IndicatorInfoProvider {
    var itemInfo: IndicatorInfo = "Results"
    
    @IBOutlet weak var predictTable: UITableView! {
        didSet {
            predictTable.delegate = self
            predictTable.dataSource = self
            predictTable.showsVerticalScrollIndicator = false
            predictTable.separatorColor = UIColor.darkGray
            predictTable.separatorStyle = .singleLineEtched
            predictTable.register(UINib(nibName: "PredictionItem", bundle: nil), forCellReuseIdentifier: "PredictionItem")
        }
    }
    
    var predictList = [PredictionModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}

extension PredictResultsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return predictList.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PredictionItem = tableView.dequeueReusableCell(withIdentifier: "PredictionItem", for: indexPath) as! PredictionItem
        
        let item = predictList[indexPath.row]
        cell.lbAsset.text = item.asset
        cell.lbPrice.text = item.price
        cell.lbStatus.text = item.result
        cell.lbPayout.text = item.payout
        cell.lbContent.text = item.content
        cell.betView.isHidden = true

        return cell
    }
}
