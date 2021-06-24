//
//  PredictionController.swift
//  wyretrade
//
//  Created by maxus on 3/4/21.
//

import Foundation
import UIKit
import XLPagerTabStrip
import NVActivityIndicatorView

class PredictPagerVC: SegmentedPagerTabStripViewController, NVActivityIndicatorViewable {
    var isReload = false
    var newList = [PredictionModel]()
    var ownerList = [PredictionModel]()
    var resultList = [PredictionModel]()
    var assetList = [PredictAssetModel]()
    var usdcBalance = ""
    
    let graySpotifyColor = UIColor(red: 21/255.0, green: 21/255.0, blue: 24/255.0, alpha: 1.0)
        let darkGraySpotifyColor = UIColor(red: 19/255.0, green: 20/255.0, blue: 20/255.0, alpha: 1.0)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        settings.style.segmentedControlColor = .green
    }
    
    override func viewDidLoad() {
        
//        settings.style.buttonBarBackgroundColor = graySpotifyColor
//                settings.style.buttonBarItemBackgroundColor = graySpotifyColor
//                settings.style.selectedBarBackgroundColor = UIColor(red: 33/255.0, green: 174/255.0, blue: 67/255.0, alpha: 1.0)
//                settings.style.buttonBarItemFont = UIFont(name: "HelveticaNeue-Light", size:14) ?? UIFont.systemFont(ofSize: 14)
//                settings.style.selectedBarHeight = 3.0
//                settings.style.buttonBarMinimumLineSpacing = 0
//                settings.style.buttonBarItemTitleColor = .black
//                settings.style.buttonBarItemsShouldFillAvailableWidth = true
//
//                settings.style.buttonBarLeftContentInset = 20
//                settings.style.buttonBarRightContentInset = 20
//
//                changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
//                    guard changeCurrentIndex == true else { return }
//                    oldCell?.label.textColor = UIColor(red: 138/255.0, green: 138/255.0, blue: 144/255.0, alpha: 1.0)
//                    newCell?.label.textColor = .white
//                }
        super.viewDidLoad()
       
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
        self.looadData()
        
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New", style: .plain, target: self, action: #selector(newPost))
        self.addLeftBarButtonWithImage(UIImage(named: "ic_menu")!)
        

        let child1 = self.storyboard?.instantiateViewController(withIdentifier: "PredictListController") as! PredictListController
        let child3 = self.storyboard?.instantiateViewController(withIdentifier: "PredictOwnerController") as! PredictOwnerController
        let child2 = self.storyboard?.instantiateViewController(withIdentifier: "PredictResultsController") as! PredictResultsController
        
        child1.predictList = newList
        child2.predictList = resultList
        child3.predictList = ownerList
        
        
//        guard isReload else {
            return [child1, child2, child3]
//        }
//
//        var childVCs = [child1, child2, child3]
//        let count = childVCs.count
//
//        for index in childVCs.indices {
//            let nElements = count - index
//            let n = (Int(arc4random()) % nElements) + index
//            if n != index {
//                childVCs.swapAt(index, n)
//            }
//        }
//        let nItems = 1 + (arc4random() % 4)
//        return Array(childVCs.prefix(Int(nItems)))
        
        
    }
    
    func looadData() {
        let param : [String : Any] = [:]
        self.startAnimating()
        RequestHandler.getPredictionList(parameter: param as NSDictionary, success: { (successResponse) in
                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            var predict : PredictionModel!
            
            if let data = dictionary["new_predict"] as? [[String:Any]] {
                
                self.newList = [PredictionModel]()
                
                for item in data {
                    predict = PredictionModel(fromDictionary: item)
                    self.newList.append(predict)
                }
            }
            if let data = dictionary["incoming"] as? [[String:Any]] {
                
                self.resultList = [PredictionModel]()
                
                for item in data {
                    predict = PredictionModel(fromDictionary: item)
                    self.resultList.append(predict)
                }
            }
            if let data = dictionary["my_post"] as? [[String:Any]] {
                
                self.ownerList = [PredictionModel]()
                
                for item in data {
                    predict = PredictionModel(fromDictionary: item)
                    self.ownerList.append(predict)
                }
            }
            
            
            self.reloadPagerTabStripView()
   
            }) { (error) in
                        self.stopAnimating()
                let alert = Alert.showBasicAlert(message: error.message)
                        self.presentVC(alert)
            }
    }
    
    func loadPredictable(param: NSDictionary) {
        self.startAnimating()
        RequestHandler.getPredictableList(parameter: param as NSDictionary, success: { (successResponse) in
                                self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            var asset : PredictAssetModel!
            
            if let historyData = dictionary["data"] as? [[String:Any]] {
                self.assetList = [PredictAssetModel]()
                for item in historyData {
                    asset = PredictAssetModel(fromDictionary: item)
                    self.assetList.append(asset)
                }
                
            }
            
            if let usdc_balance = dictionary["usdc_balance"] as? NSString {
                self.usdcBalance = NumberFormat(value: usdc_balance.doubleValue, decimal: 4).description
            } else {
                self.usdcBalance = NumberFormat(value: dictionary["usdc_balance"] as! Double, decimal: 4).description
            }
            
            if param["type"] as! Int == 0 {
                let detailController = self.storyboard?.instantiateViewController(withIdentifier: "PredictAssetListController") as! PredictAssetListController
                detailController.assetList = self.assetList
                detailController.usdcBalance = self.usdcBalance
                self.navigationController?.pushViewController(detailController, animated: true)
            } else {
                let detailController = self.storyboard?.instantiateViewController(withIdentifier: "StocksController") as! StocksController
                detailController.isPredict = true
                detailController.usdcBalance = self.usdcBalance
                self.navigationController?.pushViewController(detailController, animated: true)
            }
            
            
            
            }) { (error) in
                        self.stopAnimating()
                let alert = Alert.showBasicAlert(message: error.message)
                        self.presentVC(alert)
            }
    }
    
    @objc func newPost() {

        let alertController = UIAlertController(title: "Select", message: "", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Crypto", style: .default) { (_) in
            let param: NSDictionary = ["type": 0]
            self.loadPredictable(param: param)
        }
        let action2 = UIAlertAction(title: "Stocks, ETFs", style: .default) { action in
            let param: NSDictionary = ["type": 1]
            self.loadPredictable(param: param)
        }
        
        alertController.addAction(action1)
        alertController.addAction(action2)
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        self.presentVC(alertController);
    }
    
    @IBAction func reloadTapped(_ sender: UIBarButtonItem) {
            isReload = true
            pagerBehaviour = .common(skipIntermediateViewControllers: arc4random() % 2 == 0)
            reloadPagerTabStripView()
        }
    
}

