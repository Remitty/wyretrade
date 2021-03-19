//
//  PredictOwnerController.swift
//  wyretrade
//
//  Created by maxus on 3/4/21.
//

import Foundation
import UIKit
import XLPagerTabStrip

class PredictOwnerController: UIViewController, IndicatorInfoProvider {
    var itemInfo: IndicatorInfo = "Owner"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}
