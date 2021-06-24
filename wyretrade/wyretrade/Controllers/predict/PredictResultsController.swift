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
    @IBOutlet weak var lbEmpty: UILabel!
    
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
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
        tableHeight.constant = CGFloat( Double(predictList.count) * 150.0)
        if predictList.count > 0 {
            lbEmpty.isHidden = true
        } else {
            lbEmpty.isHidden = false
        }
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
        cell.lbStatus.text = item.status
        cell.lbPayout.text = item.payout
        cell.lbContent.text = item.content
        cell.betView.isHidden = true
        cell.cancelView.isHidden = true
        cell.remainingTime = item.remainTime
        cell.precessTimer()
        return cell
    }
}
