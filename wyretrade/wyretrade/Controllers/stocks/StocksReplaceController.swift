//
//  StocksReplaceController.swift
//  wyretrade
//
//  Created by brian on 3/17/21.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class StocksReplaceController: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet weak var lbStocksSymbol: UILabel!
    @IBOutlet weak var lbStocksName: UILabel!
    @IBOutlet weak var lbStocksPrice: UILabel!
    @IBOutlet weak var lbStocksChange: UILabel!
    @IBOutlet weak var lbShares: UILabel!
    @IBOutlet weak var lbAvgPrice: UILabel!
    @IBOutlet weak var lbHolding: UILabel!
    @IBOutlet weak var lbProfit: UILabel!
    @IBOutlet weak var imgProfit: UIImageView!
    
    @IBOutlet weak var viewChart: UIView!
    @IBOutlet weak var viewCompany: UIView!
    @IBOutlet weak var viewFirst: UIView!
    @IBOutlet weak var viewSecond: UIView!
    
    @IBOutlet weak var btnCancel: UIButton! {
        didSet {
            btnCancel.roundCornors()        }
    }

    @IBOutlet weak var btnReplace: UIButton! {
        didSet {
            btnReplace.roundCornors()
        }
    }

    var order: StocksOrderModel!
    var stocks: StockPositionModel!
    var stocksBalance = 0.0
    
    var company: CompanyModel!
    let companyView = Company().loadView() as! Company

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
//        self.loadData()
        
//        self.configCompany()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadData()
    }
    
    private func configCompany() {
        self.companyView.translatesAutoresizingMaskIntoConstraints = false
        self.viewCompany.addSubview(self.companyView)
    }
    
    func loadData() {
        self.startAnimating()
        let param : [String : Any] = ["ticker": self.order.ticker]
        RequestHandler.getStockDetail(parameter: param as NSDictionary, success: { (successResponse) in
                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            self.stocksBalance = dictionary["stock_balance"] as! Double
            
            self.stocks = StockPositionModel.init(fromDictionary: dictionary["stock"] as! [String: Any])

            var chartDayData = [ChartModel]()
            var chartWeekData = [ChartModel]()
            var chartMonthData = [ChartModel]()
            var chartMonth6Data = [ChartModel]()
            var chartYearData = [ChartModel]()
            var chartAllData = [ChartModel]()
            
            var chart : ChartModel!
            
            if let data = dictionary["aggregate_day"] as? [[String:Any]] {
                
                for item in data {
                    chart = ChartModel(fromDictionary: item)
                    chartDayData.append(chart)
                }
                
            }
            
            if let data = dictionary["aggregate_week"] as? [[String:Any]] {
                
                for item in data {
                    chart = ChartModel(fromDictionary: item)
                    chartWeekData.append(chart)
                }
                
            }
            
            if let data = dictionary["aggregate_month"] as? [[String:Any]] {
                
                for item in data {
                    chart = ChartModel(fromDictionary: item)
                    chartMonthData.append(chart)
                }
                
            }
            
            if let data = dictionary["aggregate_month6"] as? [[String:Any]] {
                
                for item in data {
                    chart = ChartModel(fromDictionary: item)
                    chartMonth6Data.append(chart)
                }
                
            }
            
            if let data = dictionary["aggregate_year"] as? [[String:Any]] {
                
                for item in data {
                    chart = ChartModel(fromDictionary: item)
                    chartYearData.append(chart)
                }
                
            }
            
            if let data = dictionary["aggregate_all"] as? [[String:Any]] {
                
                for item in data {
                    chart = ChartModel(fromDictionary: item)
                    chartAllData.append(chart)
                }
                
            }
            
//            guard let company = dictionary["company"] else {
//                return
//            }
//
//            self.company = CompanyModel(fromDictionary: company as! [String: Any])
//
//            self.companyView.lbDescription.text = self.company.description
//            self.companyView.lbIndustry.text = self.company.industry
//            self.companyView.lbDate.text = self.company.site
            
        }) { (error) in
                        self.stopAnimating()
            let alert = Alert.showBasicAlert(message: error.message)
                    self.presentVC(alert)
        }
    }
    
    func submitCancel() {
        let param = ["order_id": self.order.orderId]
    }

    @IBAction func actionCancel(_ sender: Any) {
        let alert = Alert.showConfirmAlert(message: "Are you sure cancel this order?", handler: {
            (_) in self.submitCancel()
        })
        self.presentVC(alert)
    }
    
    @IBAction func actionReplace(_ sender: Any) {
        if self.stocks != nil {
            let buyController = storyboard?.instantiateViewController(withIdentifier: "StocksBuyController") as! StocksBuyController
            buyController.stocks = self.stocks
            buyController.order = self.order
            buyController.company = self.company
            buyController.stocksBalance = self.stocksBalance
            buyController.side = "replace"
            self.navigationController?.pushViewController(buyController, animated: true)
        } else {
            self.showToast(message: "Please wait for loading data")
        }
        
    }
}
