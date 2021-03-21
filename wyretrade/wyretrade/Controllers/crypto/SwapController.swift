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
    var sellAmount = 0.0
    var selectedType = "buy"
    var buyCoin = "BTC"
    var sellCoin = "BTC"
    var exchangeRate = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.addLeftBarButtonWithImage(UIImage(named: "ic_menu")!)
        txtSellAmount.addTarget(self, action: #selector(StocksBuyController.amountTextFieldDidChange), for: .editingChanged)
        
        self.loadHistory()
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let next = segue.destination as! CoinSelectController
//        next.delegate = self
//    }
    
    @objc func amountTextFieldDidChange(_ textField: UITextField) {
        guard let amount = self.txtSellAmount.text else {
            return
        }
        
        if amount == "" {
            self.sellAmount = 0.0
        }
        self.sellAmount = Double(amount)!
        self.displayEstCost()
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
        let param : [String : Any] = ["send_coin_id": self.sellCoinId]
        
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
                let detailController = self.storyboard?.instantiateViewController(withIdentifier: "CoinSelectController") as! CoinSelectController
                detailController.delegate = self
                detailController.coinList = self.buyCoinList
                self.navigationController?.pushViewController(detailController, animated: true)
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
                let detailController = self.storyboard?.instantiateViewController(withIdentifier: "CoinSelectController") as! CoinSelectController
                detailController.delegate = self
                detailController.coinList = self.sendCoinList
                self.navigationController?.pushViewController(detailController, animated: true)
            }
        }) { (error) in
            let alert = Alert.showBasicAlert(message: error.message)
                    self.presentVC(alert)
        }
    }
    
    func displayExchangeRate() {
        self.lbSwapRate.text = "1 \(self.sellCoin) ± \(self.exchangeRate) \(self.buyCoin)"
    }
    
    func displayEstCost() {
        self.lbBuyEstAmount.text = "\(self.sellAmount * self.exchangeRate)"
    }

    @IBAction func actionSelectSellCoin(_ sender: Any) {
        self.selectedType = "sell"
        self.getSellCoins()
    }
    
    @IBAction func actionSubmit(_ sender: Any) {
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
        
        let alert = Alert.showConfirmAlert(message: "Are you sure selling \(self.sellAmount) \(self.sellCoin) ?", handler: {
            (_) in self.submitExchange()
        })
        self.presentVC(alert)
    }
    
    @IBAction func actionSelectBuyCoin(_ sender: Any) {
        if self.sellCoinId == "" {
            self.showToast(message: "Please select selling coin")
            return
        }
        self.selectedType = "buy"
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

extension SwapController: CoinSelectControllerDelegate {
    func selectCoin(param: CoinModel) {
        if self.selectedType == "buy" {
            self.buyCoinId = param.id
            self.lbBuyCoinBalance.text = param.balance
            self.buyCoin = param.symbol
            self.exchangeRate = param.exchangeRate
            self.displayExchangeRate()
            self.displayEstCost()
        } else {
            self.sellCoinId = param.id
            self.lbSellingCoinBalance.text = param.balance
            self.sellCoin = param.symbol
            self.displayExchangeRate()
        }
    }
}
