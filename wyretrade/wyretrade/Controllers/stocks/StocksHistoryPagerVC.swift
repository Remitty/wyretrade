//
//  StocksHistorPagerVC.swift
//  wyretrade
//
//  Created by brian on 3/16/21.
//

import Foundation
import XLPagerTabStrip

class StocksHistoryPagerVC: SegmentedPagerTabStripViewController {
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
    
    func loadHistoryData() {
        let param : [String : Any] = [:]
        RequestHandler.getAllOrderStocks(parameter: param as NSDictionary, success: { (successResponse) in
//                        self.stopAnimating()
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
                    self.orderList.append(deposit)
                }
                
            }
            
            
            self.reloadPagerTabStripView()
   
            }) { (error) in
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
