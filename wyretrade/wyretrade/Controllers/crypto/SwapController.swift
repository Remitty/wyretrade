//
//  SwapController.swift
//  wyretrade
//
//  Created by maxus on 3/1/21.
//

import UIKit
import NVActivityIndicatorView

class SwapController: UIViewController, UITextFieldDelegate, NVActivityIndicatorViewable {

    @IBOutlet weak var txtSellAmount: UITextField! {
        didSet {
            txtSellAmount.delegate = self
        }
    }
    @IBOutlet weak var lbSendCoinBalance: UILabel!
//    @IBOutlet weak var lbBuyCoinBalance: UILabel!
    @IBOutlet weak var lbBuyEstAmount: UILabel!
    @IBOutlet weak var lbSwapRate: UILabel!
    @IBOutlet weak var lbSendingLimit: UILabel!
    
    @IBOutlet weak var lbFee: UILabel!
    
    @IBOutlet weak var sendingIcon: UIImageView!
    @IBOutlet weak var receiveIcon: UIImageView!
    
    @IBOutlet weak var btnSendCoin: UIButton! {
        didSet {
            btnSendCoin.semanticContentAttribute = .forceRightToLeft
        }
    }
    @IBOutlet weak var btnReceiveCoin: UIButton! {
        didSet {
            btnReceiveCoin.semanticContentAttribute = .forceRightToLeft
        }
    }
    @IBOutlet weak var btnSwap: UIButton! {
        didSet {
            btnSwap.round()
        }
    }
    
    @IBOutlet weak var btnHistory: UIButton! {
        didSet {
            btnHistory.round()
        }
    }
    
    
//    @IBOutlet weak var historyTable: UITableView!{
//        didSet {
//            historyTable.delegate = self
//            historyTable.dataSource = self
//            historyTable.showsVerticalScrollIndicator = false
//            historyTable.separatorColor = UIColor.darkGray
//            historyTable.separatorStyle = .singleLineEtched
//            historyTable.register(UINib(nibName: "SwapItem", bundle: nil), forCellReuseIdentifier: "SwapItem")
//        }
//    }
    
//    var historyList = [SwapModel]()
    var sendCoinList = [CoinModel]()
    var receiveCoinList = [CoinModel]()
    
    var rateModel: SwapRateModel!
    
    var sendCoin: CoinModel!
    var receiveCoin: CoinModel!
    
    var sellAmount = 0.1
    var receiveAmount = 0.0
    var fee = 0.0
    var selectedType = "buy"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.addLeftBarButtonWithImage(UIImage(named: "ic_menu")!)
        txtSellAmount.addTarget(self, action: #selector(StocksBuyController.amountTextFieldDidChange), for: .editingChanged)
        self.loadData()
//        self.loadHistory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.loadData()
    }
    
    
    func loadData() {
        let param : [String : Any] = [:]
        self.startAnimating()
        RequestHandler.getCoinExchange(parameter: param as NSDictionary, success: { (successResponse) in
                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            var coin : CoinModel!
            
            if let coins = dictionary["coins"] as? [[String:Any]] {
                self.sendCoinList = [CoinModel]()
                self.receiveCoinList = [CoinModel]()
                for item in coins {
                    coin = CoinModel(fromDictionary: item)
//                    if coin.type == "Other" {
                        self.sendCoinList.append(coin)
//                    }
                    self.receiveCoinList.append(coin)
                }
                
            }
            
            
            self.rateModel = SwapRateModel(fromDictionary: dictionary["rate"] as! [String : Any])
            self.sendCoin = CoinModel(fromDictionary: dictionary["sendCoin"] as! [String : Any])
            self.receiveCoin = CoinModel(fromDictionary: dictionary["receiveCoin"] as! [String : Any])
            
            self.lbSendCoinBalance.text = self.sendCoin.balance
            self.receiveIcon.load(url: URL(string: self.receiveCoin.icon)!)
            self.btnReceiveCoin.setTitle(self.receiveCoin.symbol, for: .normal)
            
            self.displayFee()
            self.displayEstCost()
            self.displayExchangeRate()
            
            }) { (error) in
                        self.stopAnimating()
                let alert = Alert.showBasicAlert(message: error.message)
                        self.presentVC(alert)
            }
    }
    
    
    @objc func amountTextFieldDidChange(_ textField: UITextField) {
        guard let amount = self.txtSellAmount.text else {
            return
        }
        
        if amount.isEmpty || amount == "." {
            self.sellAmount = 0.0
        } else {
            self.sellAmount = Double(amount)!
        }
        
        self.displayFee()
        self.displayEstCost()
    }
    
//    func loadHistory() {
//        let param : [String : Any] = [:]
//        RequestHandler.getCoinExchangeList(parameter: param as NSDictionary, success: { (successResponse) in
////                        self.stopAnimating()
//            let dictionary = successResponse as! [String: Any]
//
//            var history : SwapModel!
//
//            if let historyData = dictionary["data"] as? [[String:Any]] {
//                self.historyList = [SwapModel]()
//                for item in historyData {
//                    history = SwapModel(fromDictionary: item)
//                    self.historyList.append(history)
//                }
//                self.historyTable.reloadData()
//            }
//
//
//            }) { (error) in
//                        self.stopAnimating()
//                let alert = Alert.showBasicAlert(message: error.message)
//                        self.presentVC(alert)
//            }
//    }
    
    func submitExchange() {
        
        
        
            let param : [String : Any] = [
                "sendCoin" : self.sendCoin.symbol!,
                "receiveCoin": self.receiveCoin.symbol!,
                "send_amount" : self.sellAmount,
                "receive_amount": self.receiveAmount
            ]
            
                    self.startAnimating()
            RequestHandler.coinExchange(parameter: param as NSDictionary, success: { (successResponse) in
                        self.stopAnimating()
                let dictionary = successResponse as! [String: Any]
                
//                var history : SwapModel!
                
//                self.showToast(message: dictionary["message"] as! String)
                self.showToast(message: "Requested successfully")
                
                self.sendCoin = CoinModel(fromDictionary: dictionary["sendCoin"] as! [String : Any])
                self.lbSendCoinBalance.text = self.sendCoin.balance
//                if let historyData = dictionary["history"] as? [[String:Any]] {
//                    self.historyList = [SwapModel]()
//                    for item in historyData {
//                        history = SwapModel(fromDictionary: item)
//                        self.historyList.append(history)
//                    }
//                    self.historyTable.reloadData()
//                }
            }) { (error) in
                        self.stopAnimating()
                let alert = Alert.showBasicAlert(message: error.message)
                        self.presentVC(alert)
            }
        
    }
    
    func getBuyCoins() {
        let param : [String : Any] = ["send_coin_id": self.sendCoin.id!]
        
        self.startAnimating()
        RequestHandler.coinExchangeBuyAssets(parameter: param as NSDictionary, success: { (successResponse) in
                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            var coin : CoinModel!
            
//            if let coins = dictionary["assets"] as? [[String:Any]] {
//                self.buyCoinList = [CoinModel]()
//                for item in coins {
//                    coin = CoinModel(fromDictionary: item)
//                    self.buyCoinList.append(coin)
//                }
//                let detailController = self.storyboard?.instantiateViewController(withIdentifier: "CoinSelectController") as! CoinSelectController
//                detailController.delegate = self
//                detailController.coinList = self.buyCoinList
//                self.navigationController?.pushViewController(detailController, animated: true)
//            }
        }) { (error) in
                        self.stopAnimating()
            let alert = Alert.showBasicAlert(message: error.message)
                    self.presentVC(alert)
        }
    }
    
    func getSellCoins() {
        let param : [String : Any] = [:]
        
        self.startAnimating()
        RequestHandler.coinExchangeSendAssets(parameter: param as NSDictionary, success: { (successResponse) in
                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            var coin : CoinModel!
            
            if let coins = dictionary["assets"] as? [[String:Any]] {
////                self.sendCoinList = [CoinModel]()
////                for item in coins {
////                    coin = CoinModel(fromDictionary: item)
////                    self.sendCoinList.append(coin)
////                }
//                let detailController = self.storyboard?.instantiateViewController(withIdentifier: "CoinSelectController") as! CoinSelectController
//                detailController.delegate = self
//                detailController.coinList = self.sendCoinList
//                self.navigationController?.pushViewController(detailController, animated: true)
            }
        }) { (error) in
                        self.stopAnimating()
            let alert = Alert.showBasicAlert(message: error.message)
                    self.presentVC(alert)
        }
    }
    
    func getRate() {
        let param : [String : Any] = [
            "sendCoin": self.sendCoin.symbol!,
            "receiveCoin": self.receiveCoin.symbol!
        ]
        
        self.startAnimating()
        RequestHandler.getCoinExchangeRate(parameter: param as NSDictionary, success: { (successResponse) in
                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            self.rateModel = SwapRateModel(fromDictionary: dictionary["rate"] as! [String: Any])
            
            self.displayFee()
            self.displayEstCost()
            self.displayExchangeRate()
            
        }) { (error) in
                        self.stopAnimating()
            let alert = Alert.showBasicAlert(message: error.message)
                    self.presentVC(alert)
        }
    }
    
    func displayExchangeRate() {
        self.lbSwapRate.text = "1 \(self.sendCoin.symbol!) ± \(self.rateModel.rate!) \(self.receiveCoin.symbol!)"
        self.lbSendingLimit.text = "\(self.rateModel.min!) - \(self.rateModel.max!)"
        
    }
    
    func displayEstCost() {
        
        self.lbBuyEstAmount.text = NumberFormat(value: self.receiveAmount - self.fee, decimal: 4).description
    }
    
    func displayFee() {
        let sysFee = self.sellAmount * self.rateModel.systemFeePerc*0.01 * self.rateModel.rate
        let sendFee = self.rateModel.sendFee * self.rateModel.rate
        self.receiveAmount = self.sellAmount * self.rateModel.rate - sendFee - sysFee
        self.fee = sysFee + self.rateModel.fee + sendFee
        self.lbFee.text = NumberFormat(value: self.fee, decimal: 6).description
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let next = segue.destination as! CoinSelectController
        next.delegate = self
        if self.selectedType == "sell" {
            next.coinList = self.sendCoinList
        } else {
            next.coinList = self.receiveCoinList
        }
        
        
    }

    @IBAction func actionSelectSellCoin(_ sender: Any) {
        self.selectedType = "sell"
//        self.getSellCoins()
        let detailController = self.storyboard?.instantiateViewController(withIdentifier: "CoinSelectController") as! CoinSelectController
        detailController.delegate = self
        detailController.coinList = self.sendCoinList
        self.navigationController?.pushViewController(detailController, animated: true)
//        performSegue(withIdentifier: "swapcoinlist", sender: sender)
    }
    
    @IBAction func actionSelectBuyCoin(_ sender: Any) {
//        if self.sellCoinId == "" {
//            self.showToast(message: "Please select selling coin")
//            return
//        }
        self.selectedType = "buy"
        let detailController = self.storyboard?.instantiateViewController(withIdentifier: "CoinSelectController") as! CoinSelectController
        detailController.delegate = self
        detailController.coinList = self.receiveCoinList
        self.navigationController?.pushViewController(detailController, animated: true)
//        self.getBuyCoins()
//        performSegue(withIdentifier: "swapcoinlist", sender: sender)
    }
    
    @IBAction func actionSubmit(_ sender: Any) {
        
        if self.sellAmount == 0 {
            self.txtSellAmount.shake(6, withDelta: 10, speed: 0.06)
            return
        }
        
        if self.sellAmount > Double(self.sendCoin.balance)! {
            self.showToast(message: "Insufficient balance")
            return
        }
        let defaults = UserDefaults.init()
        let alert = Alert.showConfirmAlert(message: "Are you sure swap \(self.sellAmount) \(self.sendCoin.symbol!)? \(defaults.string(forKey: "msgCoinSwapFeePolicy")!)", handler: {
            (_) in self.submitExchange()
        })
        self.presentVC(alert)
    }
    

    
    @IBAction func actionViewHistory(_ sender: Any) {
        let detailController = self.storyboard?.instantiateViewController(withIdentifier: "SwapHistoryController") as! SwapHistoryController
        self.navigationController?.pushViewController(detailController, animated: true)
    }
    
}

//extension SwapController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return historyList.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell: SwapItem = tableView.dequeueReusableCell(withIdentifier: "SwapItem", for: indexPath) as! SwapItem
//        let item = historyList[indexPath.row]
//        cell.lbSend.text = "\(item.amount!) \(item.sendSymbol!)"
//        cell.lbGet.text = item.getSymbol
//        cell.lbDate.text = item.date
//        cell.lbStatus.text = item.status
//
//        return cell
//    }
//}

extension SwapController: CoinSelectControllerDelegate {
    func selectCoin(param: CoinModel) {
        if self.selectedType == "buy" {
            self.receiveCoin = param
            self.receiveIcon.load(url: URL(string: param.icon)!)
//            self.lbBuyCoinBalance.text = param.balance
            self.btnReceiveCoin.setTitle(param.symbol, for: UIControl.State.normal)

        } else {
            self.sendCoin = param
            self.lbSendCoinBalance.text = param.balance
            self.sendingIcon.load(url: URL(string: param.icon)!)
            self.btnSendCoin.setTitle(param.symbol, for: UIControl.State.normal)
            
        }
        
        self.getRate()
    }
}
