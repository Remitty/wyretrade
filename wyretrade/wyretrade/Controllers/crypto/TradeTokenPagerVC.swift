//
//  TradeTokenPagerVC.swift
//  wyretrade
//
//  Created by brian on 3/18/21.
//

import Foundation
import XLPagerTabStrip
import NVActivityIndicatorView

class TradeTokenPagerVC: SegmentedPagerTabStripViewController, NVActivityIndicatorViewable {
    
    
    var isReload = false
    var depositFromBankList = [StocksDepositModel]()
    var depositFromCoinList = [StocksDepositModel]()
    var usdcBalance = 0.0
    var usdBalance = ""
    var stocksBalance = 0.0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        settings.style.barBackgroundColor = .white
//        settings.style.selectedBarBackgroundColor = .green
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        self.looadData()
        
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {

        let child1 = self.storyboard?.instantiateViewController(withIdentifier: "TokenBuyController") as! TokenBuyController
        let child2 = self.storyboard?.instantiateViewController(withIdentifier: "TokenSellController") as! TokenSellController
        
//        child1.depositFromCoinList = self.depositFromCoinList
//        child1.stocksBalance = self.stocksBalance
//        child1.usdcBalance = self.usdcBalance
//
//        child2.depositFromBankList = self.depositFromBankList
//        child2.stocksBalance = self.stocksBalance
//        child2.usdBalance = self.usdBalance
        
        guard isReload else {
            return [child1, child2]
        }
        
        var childVCs = [child1, child2]
        let count = childVCs.count
        
        for index in childVCs.indices {
            let nElements = count - index
            let n = (Int(arc4random()) % nElements) + index
            if n != index {
                childVCs.swapAt(index, n)
            }
        }
        let nItems = 1 + (arc4random() % 4)
        return Array(childVCs.prefix(Int(nItems)))
    }
    
    func looadData() {
        let param : [String : Any] = [:]
        self.startAnimating()
        RequestHandler.getUserBalance(parameter: param as NSDictionary, success: { (successResponse) in
                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            var deposit : StocksDepositModel!
            
            if let data = dictionary["coin_stock_transfer"] as? [[String:Any]] {
                self.depositFromBankList = [StocksDepositModel]()
                self.depositFromCoinList = [StocksDepositModel]()
                
                for item in data {
                    deposit = StocksDepositModel(fromDictionary: item)
                    self.depositFromBankList.append(deposit)
                    self.depositFromCoinList.append(deposit)
                }
                
                
            }
            
            if let usdcBalance = (dictionary["usdc_balance"] as? NSString)?.doubleValue {
                self.usdcBalance = usdcBalance
            } else {
                self.usdcBalance = dictionary["usdc_balance"] as! Double
            }
            
            if let stockBalance = (dictionary["stock_balance"] as? NSString)?.doubleValue {
                self.stocksBalance = stockBalance
            } else {
                self.stocksBalance = dictionary["stock_balance"] as! Double
            }
            
            self.usdBalance = dictionary["bank_usd_balance"] as! String
            
//            self.reloadPagerTabStripView()
   
            }) { (error) in
                        self.stopAnimating()
                let alert = Alert.showBasicAlert(message: error.message)
                        self.presentVC(alert)
            }
    }
    
    @IBAction func reloadTapped(_ sender: UIBarButtonItem) {
            isReload = true
            pagerBehaviour = .common(skipIntermediateViewControllers: arc4random() % 2 == 0)
            reloadPagerTabStripView()
        }
}

