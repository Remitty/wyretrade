//
//  SwapController.swift
//  wyretrade
//
//  Created by maxus on 3/1/21.
//

import UIKit

class SwapController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtSellAmount: UITextField! {
        didSet {
            txtSellAmount.delegate = self
        }
    }
    @IBOutlet weak var lbSellingCoinBalance: UILabel!
    @IBOutlet weak var lbBuyCoinBalance: UILabel!
    @IBOutlet weak var lbBuyEstAmount: UILabel!
    @IBOutlet weak var lbSwapRate: UILabel!
    
    @IBOutlet weak var historyTable: UITableView!{
        didSet {
            historyTable.delegate = self
            historyTable.dataSource = self
            historyTable.showsVerticalScrollIndicator = false
            historyTable.separatorColor = UIColor.darkGray
            historyTable.separatorStyle = .singleLineEtched
            historyTable.register(UINib(nibName: "SwapItem", bundle: nil), forCellReuseIdentifier: "SwapItem")
        }
    }
    
    var historyList = [SwapModel]()
    var sendCoinList = [CoinModel]()
    var buyCoinList = [CoinModel]()
    
    var buyCoinId = ""
    var sellCoinId = ""
    var sellAmount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.addLeftBarButtonWithImage(UIImage(named: "ic_menu")!)
        
        self.loadHistory()
    }
    
    func loadHistory() {
        let param : [String : Any] = [:]
        RequestHandler.getCoinExchangeList(parameter: param as NSDictionary, success: { (successResponse) in
//                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            var history : SwapModel!
            
            if let historyData = dictionary["data"] as? [[String:Any]] {
                self.historyList = [SwapModel]()
                for item in historyData {
                    history = SwapModel(fromDictionary: item)
                    self.historyList.append(history)
                }
                self.historyTable.reloadData()
            }
                    
            
            }) { (error) in
                let alert = Alert.showBasicAlert(message: error.message)
                        self.presentVC(alert)
            }
    }
    
    func submitExchange() {
        if self.sellCoinId == "" {
            self.showToast(message: "Please select selling coin")
            return
        }
        if self.buyCoinId == "" {
            self.showToast(message: "Please select buying coin")
            return
        }
        if self.sellAmount == 0 {
            self.txtSellAmount.shake(6, withDelta: 10, speed: 0.06)
            return
        }
        
        
            let param : [String : Any] = [
                "buy_coin_id" : self.buyCoinId,
                "sell_coin_id": self.sellCoinId,
                "sell_amount" : self.sellAmount,
            ]
            
//                    self.showLoader()
            RequestHandler.coinExchange(parameter: param as NSDictionary, success: { (successResponse) in
//                        self.stopAnimating()
                let dictionary = successResponse as! [String: Any]
                
                var history : SwapModel!
                
                self.showToast(message: dictionary["message"] as! String)
                
                if let historyData = dictionary["history"] as? [[String:Any]] {
                    self.historyList = [SwapModel]()
                    for item in historyData {
                        history = SwapModel(fromDictionary: item)
                        self.historyList.append(history)
                    }
                    self.historyTable.reloadData()
                }
            }) { (error) in
                let alert = Alert.showBasicAlert(message: error.message)
                        self.presentVC(alert)
            }
        
    }
    
    func getBuyCoins() {
        let param : [String : Any] = [:]
        
//                    self.showLoader()
        RequestHandler.coinExchangeBuyAssets(parameter: param as NSDictionary, success: { (successResponse) in
//                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            var coin : CoinModel!
            
            if let coins = dictionary["assets"] as? [[String:Any]] {
                self.buyCoinList = [CoinModel]()
                for item in coins {
                    coin = CoinModel(fromDictionary: item)
                    self.buyCoinList.append(coin)
                }
                
            }
        }) { (error) in
            let alert = Alert.showBasicAlert(message: error.message)
                    self.presentVC(alert)
        }
    }
    
    func getSellCoins() {
        let param : [String : Any] = [:]
        
//                    self.showLoader()
        RequestHandler.coinExchangeSendAssets(parameter: param as NSDictionary, success: { (successResponse) in
//                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            var coin : CoinModel!
            
            if let coins = dictionary["assets"] as? [[String:Any]] {
                self.sendCoinList = [CoinModel]()
                for item in coins {
                    coin = CoinModel(fromDictionary: item)
                    self.sendCoinList.append(coin)
                }
                
            }
        }) { (error) in
            let alert = Alert.showBasicAlert(message: error.message)
                    self.presentVC(alert)
        }
    }

    @IBAction func actionSelectSellCoin(_ sender: Any) {
        self.getSellCoins()
    }
    
    @IBAction func actionSubmit(_ sender: Any) {
        self.submitExchange()
    }
    @IBAction func actionSelectBuyCoin(_ sender: Any) {
        if self.sellCoinId == "" {
            self.showToast(message: "Please select selling coin")
            return
        }
        
        self.getBuyCoins()
    }
}

extension SwapController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SwapItem = tableView.dequeueReusableCell(withIdentifier: "SwapItem", for: indexPath) as! SwapItem
        let item = historyList[indexPath.row]
        cell.lbSend.text = "\(item.amount!) \(item.sendSymbol!)"
        cell.lbGet.text = item.getSymbol
        cell.lbDate.text = item.date
        cell.lbStatus.text = item.status
        
        return cell
    }
}
