//
//  StocksDepositPagerVC.swift
//  wyretrade
//
//  Created by brian on 3/15/21.
//

import Foundation
import XLPagerTabStrip
import NVActivityIndicatorView

class StocksDepositPagerVC: SegmentedPagerTabStripViewController, NVActivityIndicatorViewable {
    var isReload = false
    var depositFromBankList = [StocksDepositModel]()
    var depositFromCoinList = [StocksDepositModel]()
    var usdcBalance = 0.0
    var usdBalance = ""
    var stocksBalance = 0.0
    var card: CardModel!
    var paypal: [String: Any]!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        settings.style.segmentedControlColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.looadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {

        let child1 = self.storyboard?.instantiateViewController(withIdentifier: "StocksDepositCoinController") as! StocksDepositCoinController
        let child2 = self.storyboard?.instantiateViewController(withIdentifier: "StocksDepositCardController") as! StocksDepositCardController
        let child3 = self.storyboard?.instantiateViewController(withIdentifier: "StocksDepositPaypalController") as! StocksDepositPaypalController
        
        
        child1.stocksBalance = self.stocksBalance
        child1.usdcBalance = self.usdcBalance
        
        
        child2.stocksBalance = self.stocksBalance
        child2.card = self.card
        
        child3.stocksBalance = self.stocksBalance
        child3.paypal = self.paypal
        
        return [child1, child2, child3]
        
        
    }
    
    func looadData() {
        let param : [String : Any] = [:]
        self.startAnimating()
        RequestHandler.getUserBalance(parameter: param as NSDictionary, success: { (successResponse) in
                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            
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
            
            self.card = CardModel(fromDictionary: dictionary["card"] as! [String: Any])
            self.paypal = dictionary["paypal"] as? [String: Any]
            
            self.reloadPagerTabStripView()
   
            }) { (error) in
                        self.stopAnimating()
                let alert = Alert.showBasicAlert(message: error.message)
                        self.presentVC(alert)
            }
    }

}
