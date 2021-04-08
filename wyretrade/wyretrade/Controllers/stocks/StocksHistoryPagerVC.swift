//
//  StocksHistorPagerVC.swift
//  wyretrade
//
//  Created by brian on 3/16/21.
//

import Foundation
import XLPagerTabStrip
import NVActivityIndicatorView

class StocksHistoryPagerVC: SegmentedPagerTabStripViewController, NVActivityIndicatorViewable {
    var isReload = false
    var orderList = [StocksOrderModel]()
    var historyList = [StocksOrderModel]()
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        settings.style.segmentedControlColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //        self.addLeftBarButtonWithImage(UIImage(named: "ic_menu")!)
//        self.loadHistoryData()
        self.loadOrderData()
    }
   
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {

        let child1 = self.storyboard?.instantiateViewController(withIdentifier: "StocksOrderController") as! StocksOrderController
        let child2 = self.storyboard?.instantiateViewController(withIdentifier: "StocksHistoryController") as! StocksHistoryController
        
        child1.orderList = self.orderList
        child2.historyList = self.historyList
        
        
        return [child1, child2]
    }
    
    func loadHistoryData() {
        let param : [String : Any] = [:]
        self.startAnimating()
        RequestHandler.getAllOrderStocks(parameter: param as NSDictionary, success: { (successResponse) in
                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            var deposit : StocksOrderModel!
            
            if let data = dictionary["stocks"] as? [[String:Any]] {
                
                self.historyList = [StocksOrderModel]()
                
                for item in data {
                    deposit = StocksOrderModel(fromDictionary: item)
                    
                    self.historyList.append(deposit)
                    
                }
                
                
            }
            
            
            self.reloadPagerTabStripView()
   
            }) { (error) in
                        self.stopAnimating()
                let alert = Alert.showBasicAlert(message: error.message)
                        self.presentVC(alert)
            }
    }
    
    func loadOrderData() {
        let param : [String : Any] = [:]
        RequestHandler.getPendingStocks(parameter: param as NSDictionary, success: { (successResponse) in
//                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            var deposit : StocksOrderModel!
            
            if let data = dictionary["stocks"] as? [[String:Any]] {
                self.orderList = [StocksOrderModel]()
                
                
                for item in data {
                    deposit = StocksOrderModel(fromDictionary: item)
                    self.orderList.append(deposit)
                    
                }
                
            }
            
            if let data = dictionary["all"] as? [[String:Any]] {
                self.historyList = [StocksOrderModel]()
                
                
                for item in data {
                    deposit = StocksOrderModel(fromDictionary: item)
                    self.historyList.append(deposit)
//                    self.orderList.append(deposit)
                }
                
            }
            
            
            self.reloadPagerTabStripView()
   
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
