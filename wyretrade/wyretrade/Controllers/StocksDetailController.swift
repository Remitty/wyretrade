//
//  StocksDetailController.swift
//  wyretrade
//
//  Created by maxus on 3/4/21.
//

import Foundation
import UIKit

class StocksDetailController: UIViewController {
    
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
    
    var stocks: StockPositionModel = StockPositionModel.init(fromDictionary: ["avg_price" : "2.33",
                                                                              "change" : "-0.07",
                                                                              "change_percent" : "-2.88",
                                                                              "current_price" : "2.36",
                                                                              "filled_qty" : 12,
                                                                              "holding" : "28.32",
                                                                              "name" : "Verastem, Inc.",
                                                                              "profit" : "-0.84",
                                                                              "symbol" : "VSTM"])
    let companyView = Company().loadView() as! Company

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.lbStocksSymbol.text = self.stocks.ticker
        self.lbStocksName.text = self.stocks.name
        self.lbStocksPrice.text = self.stocks.price
        self.lbStocksChange.text = "$\(self.stocks.changeToday!) (\(self.stocks.changeTodayPercent!)%)  Today"
        self.lbShares.text = "\(self.stocks.shares!)"
        self.lbAvgPrice.text = self.stocks.avgPrice
        self.lbHolding.text = self.stocks.holding
        self.lbProfit.text = self.stocks.profit
        if self.stocks.dbProfit >= 0 {
            self.lbProfit.textColor = UIColor.green
            self.lbStocksChange.textColor = UIColor.green
            self.imgProfit.image = UIImage(named: "ic_up")
        } else {
            self.lbProfit.textColor = UIColor.red
            self.lbStocksChange.textColor = UIColor.red
            self.imgProfit.image = UIImage(named: "ic_down")
        }
        
        self.loadData()
        
        self.configCompany()
        
    }
    
    private func configCompany() {
        self.companyView.translatesAutoresizingMaskIntoConstraints = false
        self.viewCompany.addSubview(self.companyView)
    }
    
    func loadData() {
        let param : [String : Any] = ["ticker": self.stocks.ticker]
        RequestHandler.getStockDetail(parameter: param as NSDictionary, success: { (successResponse) in
//                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            let company = CompanyModel(fromDictionary: dictionary["company"] as! [String: Any])

            self.companyView.lbDescription.text = company.description
            self.companyView.lbIndustry.text = company.industry
            self.companyView.lbDate.text = company.site
            
        }) { (error) in
            let alert = Alert.showBasicAlert(message: error.message)
                    self.presentVC(alert)
        }
    }

    @IBAction func actionBuy(_ sender: Any) {
    }
    
    @IBAction func actionSell(_ sender: Any) {
    }
}
