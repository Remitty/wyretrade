//
//  CoinTradePagerVC.swift
//  wyretrade
//
//  Created by brian on 3/28/21.
//

import Foundation
import XLPagerTabStrip

class CoinTradePagerVC: SegmentedPagerTabStripViewController {
    var isReload = false
    
    var coinList = [CoinModel]()
    var onramperApiKey: String!
    var xanpoolApiKey: String!
    var onRamperCoins = ""
    
    var currentIdx = 0
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        settings.style.barBackgroundColor = .white
//        settings.style.selectedBarBackgroundColor = .green
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {

        let child2 = self.storyboard?.instantiateViewController(withIdentifier: "CoinTradeController") as! CoinTradeController
        let child1 = self.storyboard?.instantiateViewController(withIdentifier: "TradeTokenController") as! TradeTokenController
        pagerTabStripController.offsetForChild(at: currentIdx)
        child2.coinList = self.coinList
        child2.onRamperCoins = self.onRamperCoins
        child2.onramperApiKey = self.onramperApiKey
        child2.xanpoolApiKey = self.xanpoolApiKey
 
        return [child1, child2]
        
        
    }
  
}
