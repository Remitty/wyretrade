//
//  PredictionController.swift
//  wyretrade
//
//  Created by maxus on 3/4/21.
//

import Foundation
import UIKit
import XLPagerTabStrip

class PredictPagerVC: SegmentedPagerTabStripViewController {
    var isReload = false
    var newList = [PredictionModel]()
    var ownerList = [PredictionModel]()
    var resultList = [PredictionModel]()
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        settings.style.segmentedControlColor = .green
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //        self.addLeftBarButtonWithImage(UIImage(named: "ic_menu")!)
        self.looadData()
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {

        let child1 = self.storyboard?.instantiateViewController(withIdentifier: "PredictListController") as! PredictListController
        let child3 = self.storyboard?.instantiateViewController(withIdentifier: "PredictOwnerController") as! PredictOwnerController
        let child2 = self.storyboard?.instantiateViewController(withIdentifier: "PredictResultsController") as! PredictResultsController
        
        child1.predictList = newList
        child2.predictList = resultList
        child3.predictList = ownerList
        
        
        guard isReload else {
            return [child1, child2, child3]
        }
        
        var childVCs = [child1, child2, child3]
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
        RequestHandler.getPredictionList(parameter: param as NSDictionary, success: { (successResponse) in
//                        self.stopAnimating()
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
                let alert = Alert.showBasicAlert(message: error.message)
                        self.presentVC(alert)
            }
    }
    
    @IBAction func reloadTapped(_ sender: UIBarButtonItem) {
            isReload = true
            pagerBehaviour = .common(skipIntermediateViewControllers: arc4random() % 2 == 0)
            reloadPagerTabStripView()
        }
    @IBAction func actionPredict(_ sender: Any) {
    }
}

