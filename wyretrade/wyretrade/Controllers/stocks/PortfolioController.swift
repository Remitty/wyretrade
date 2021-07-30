//
//  PortfolioController.swift
//  wyretrade
//
//  Created by maxus on 3/4/21.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class PortfolioController: UIViewController, NVActivityIndicatorViewable {

    @IBOutlet weak var lbBalance: UILabel!
    @IBOutlet weak var lbPortfolio: UILabel!
    @IBOutlet weak var lbProfit: UILabel!
    @IBOutlet weak var lbMargin: UILabel!
    @IBOutlet weak var imgProfit: UIImageView!
    
    
    @IBOutlet weak var stocksTable: UITableView!{
        didSet {
            stocksTable.delegate = self
            stocksTable.dataSource = self
            stocksTable.showsVerticalScrollIndicator = false
            stocksTable.separatorColor = UIColor.label
            stocksTable.separatorStyle = .singleLine
            stocksTable.register(UINib(nibName: "StockPosition", bundle: nil), forCellReuseIdentifier: "StockPosition")
        }
    }
    
    @IBOutlet weak var btnTrade: UIButton! {
        didSet {
            btnTrade.roundCornors()
        }
    }
    
    @IBOutlet weak var btnDeposit: UIButton! {
        didSet {
            btnDeposit.roundCornors()
        }
    }
    
    @IBOutlet weak var btnWithdraw: UIButton! {
        didSet {
            btnWithdraw.roundCornors()
        }
    }
    var stocksList = [StockPositionModel]()
    var stockAutoSell = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.addLeftBarButtonWithImage(UIImage(named: "ic_menu")!)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
        self.loadData()
       
    }

    func loadData() {
        self.startAnimating()
        let param : [String : Any] = [:]
        RequestHandler.getInvestedStocks(parameter: param as NSDictionary, success: { (successResponse) in
                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            var stocks : StockPositionModel!
            
            if let data = dictionary["stocks"] as? [[String:Any]] {
                self.stocksList = [StockPositionModel]()
                for item in data {
                    stocks = StockPositionModel(fromDictionary: item)
                    self.stocksList.append(stocks)
                    
                }
                self.stocksTable.reloadData()
            }
            
            self.lbBalance.text = PriceFormat.init(amount: (dictionary["stock_balance"] as! NSString).doubleValue, currency: Currency.usd).description
            self.lbPortfolio.text = PriceFormat.init(amount: (dictionary["total_balance"] as! NSString).doubleValue, currency: Currency.usd).description
            self.lbMargin.text = PriceFormat.init(amount: (dictionary["margin_balance"] as! NSString).doubleValue, currency: Currency.usd).description
            
            var profit: Double = (dictionary["stock_profit"] as! NSString).doubleValue
            self.lbProfit.text = PriceFormat.init(amount: profit, currency: Currency.usd).description
            
            if profit >= 0 {
                self.lbProfit.textColor = UIColor.systemGreen
                self.imgProfit.image = UIImage(named: "ic_up")
            } else {
                self.lbProfit.textColor = UIColor.systemRed
                self.imgProfit.image = UIImage(named: "ic_down")
            }
            
            self.stockAutoSell = dictionary["stock_auto_sell"] as! Bool
                    
                
            }) { (error) in
                        self.stopAnimating()
                let alert = Alert.showBasicAlert(message: error.message)
                        self.presentVC(alert)
            }
    }

}


extension PortfolioController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stocksList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        
        let item = stocksList[indexPath.row]
        
        let detailController = storyboard?.instantiateViewController(withIdentifier: "StocksDetailController") as! StocksDetailController
        detailController.stocks = item
        
        self.navigationController?.pushViewController(detailController, animated: true)

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: StockPosition = tableView.dequeueReusableCell(withIdentifier: "StockPosition", for: indexPath) as! StockPosition
        let item = stocksList[indexPath.row]
        cell.lbStocksSymbol.text = item.ticker
        cell.lbStocksName.text = item.name
        cell.lbStocksChangeToday.text = "$\(item.changeToday!)"
        cell.lbStocksShares.text = "\(item.shares!) Shares"
        cell.lbStocksPrice.text = item.price
        cell.lbHolding.text = item.holding
        cell.lbProfit.text = item.profit
        
        if item.changeToday >= 0 {
            cell.lbProfit.textColor = UIColor.green
            cell.lbStocksChangeToday.textColor = UIColor.green
            cell.imgProfit.image = UIImage(named: "ic_up")
        } else {
            cell.lbProfit.textColor = UIColor.red
            cell.lbStocksChangeToday.textColor = UIColor.red
            cell.imgProfit.image = UIImage(named: "ic_down")
        }
        
        return cell
    }
}
