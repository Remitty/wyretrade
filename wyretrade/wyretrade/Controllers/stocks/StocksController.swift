//
//  StocksController.swift
//  wyretrade
//
//  Created by maxus on 3/1/21.
//

import UIKit
import NVActivityIndicatorView

class StocksController: UIViewController, UISearchBarDelegate, NVActivityIndicatorViewable {

    @IBOutlet weak var txtSearch: UISearchBar!
    @IBOutlet weak var stocksTable: UITableView!{
        didSet {
            stocksTable.delegate = self
            stocksTable.dataSource = self
            stocksTable.showsVerticalScrollIndicator = false
            stocksTable.separatorColor = UIColor.darkGray
            stocksTable.separatorStyle = .singleLineEtched
            stocksTable.register(UINib(nibName: "StocksItem", bundle: nil), forCellReuseIdentifier: "StocksItem")
        }
    }
    
    var stocksList = [StockPositionModel]()
    var query = ""
    var usdcBalance = ""
    var isPredict = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        txtSearch.showsScopeBar = true
        txtSearch.delegate = self
        
//        self.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadData()
    }

    func loadData() {
        var param : [String : Any] = [:]
        if query != "" {
            param = [ "search": self.query]
        }
        self.startAnimating()
        RequestHandler.searchStocks(parameter: param as NSDictionary, success: { (successResponse) in
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
            
            
                
            }) { (error) in
                        self.stopAnimating()
                let alert = Alert.showBasicAlert(message: error.message)
                        self.presentVC(alert)
            }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar!)
    {
        
        self.query = searchBar.text!
        self.loadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }


}


extension StocksController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stocksList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        
        let item = stocksList[indexPath.row]
        if self.isPredict {
            let detailController = storyboard?.instantiateViewController(withIdentifier: "PredictionPostController") as! PredictionPostController
            detailController.usdcBalance = self.usdcBalance
    //        detailController.asset = item
            detailController.symbol = item.ticker
            detailController.name = item.name
            detailController.price = item.price
            detailController.kind = 1
    //        detailController.id = item.id
            
            self.navigationController?.pushViewController(detailController, animated: true)
        } else {
            let detailController = storyboard?.instantiateViewController(withIdentifier: "StocksDetailController") as! StocksDetailController
            detailController.stocks = item
            
            self.navigationController?.pushViewController(detailController, animated: true)
        }
        

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: StocksItem = tableView.dequeueReusableCell(withIdentifier: "StocksItem", for: indexPath) as! StocksItem
        let item = stocksList[indexPath.row]
        cell.lbStocksSymbol.text = item.ticker
        cell.lbStocksName.text = item.name
        cell.lbStocksChangePercent.text = NumberFormat.init(value: item.changeTodayPercent!, decimal: 4).description + "%"
        if item.changeTodayPercent >= 0 {
            cell.lbStocksChangePercent.textColor = UIColor.green
        } else {
            cell.lbStocksChangePercent.textColor = UIColor.red
        }
        cell.lbStocksShares.text = "\(item.shares!) Shares"
        cell.lbStocksPrice.text = item.price
        
        return cell
    }
}
