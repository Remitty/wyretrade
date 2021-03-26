//
//  CoinsController.swift
//  wyretrade
//
//  Created by maxus on 3/1/21.
//

import UIKit
import PopupDialog
import SafariServices

class CoinsController: UIViewController {
    
    
    @IBOutlet weak var lbHolding: UILabel!
    @IBOutlet weak var lbChangePercent: UILabel!
    @IBOutlet weak var imgChange: UIImageView!
    @IBOutlet weak var coinTable: UITableView! {
        didSet {
            coinTable.delegate = self
            coinTable.dataSource = self
            coinTable.showsVerticalScrollIndicator = false
            coinTable.separatorColor = UIColor.darkGray
            coinTable.separatorStyle = .singleLineEtched
            coinTable.register(UINib(nibName: "CoinView", bundle: nil), forCellReuseIdentifier: "CoinView")
        }
    }
    
    var coinList = [CoinModel]()
    var onramperApiKey: String!
    var xanpoolApiKey: String!
    var onRamperCoins = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.addLeftBarButtonWithImage(UIImage(named: "ic_menu")!)
        
        self.loadData()
    }

    
    
    func loadData() {
        let param : [String : Any] = [:]
        RequestHandler.getCoins(parameter: param as NSDictionary, success: { (successResponse) in
//                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            var coin : CoinModel!
            
            if let coinData = dictionary["coins"] as? [[String:Any]] {
                self.coinList = [CoinModel]()
                for item in coinData {
                    coin = CoinModel(fromDictionary: item)
                    self.coinList.append(coin)
                    self.onRamperCoins += coin.symbol + ","
                }
                self.coinTable.reloadData()
            }
            
            self.lbHolding.text = PriceFormat.init(amount: (dictionary["total_balance"] as! NSString).doubleValue, currency: Currency.usd).description
            
            var effect: Double = (dictionary["total_effect"] as! NSString).doubleValue
            self.lbChangePercent.text = NumberFormat.init(value: effect, decimal: 4).description + " %"
            
            if effect >= 0 {
                self.lbChangePercent.textColor = UIColor.green
                self.imgChange.image = UIImage(named: "ic_up")
            } else {
                self.lbChangePercent.textColor = UIColor.red
                self.imgChange.image = UIImage(named: "ic_down")
            }
            
            self.onramperApiKey = dictionary["onramper_api_key"] as? String
            self.xanpoolApiKey = dictionary["xanpool_api_key"] as? String
                    
                
            }) { (error) in
                let alert = Alert.showBasicAlert(message: error.message)
                        self.presentVC(alert)
            }
    }
    
    func actionXanpool(param: NSDictionary) {
        RequestHandler.coinDeposit(parameter: param, success: {(successResponse) in
            let dictionary = successResponse as! [String: Any]
            
            var address = dictionary["address"] as! String
            
            let base = "https://checkout.xanpool.com/"
            let apiKey = "?apiKey=\(self.xanpoolApiKey!)"
            let wallet = "&owallet=\(address)"
            let symbol = "&cryptoCurrency=\(param["symbol"]!)"
            let transactionType = "&transactionType="
            let isWebview = "&isWebview=true"
            let partner = "&partnerData=88824d8683434f4e"
             let url = base + apiKey + wallet + symbol + transactionType + isWebview + partner
            
            let webviewController = self.storyboard?.instantiateViewController(withIdentifier: "webVC") as! webVC
            webviewController.url = url
            self.navigationController?.pushViewController(webviewController, animated: true)
            
        }) {
            (error) in
            let alert = Alert.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
    func actionRamp(param: NSDictionary) {
        RequestHandler.coinDeposit(parameter: param, success: {(successResponse) in
            let dictionary = successResponse as! [String: Any]
            
            var address = dictionary["address"] as! String
            
            var configuration = Ramp.Configuration(url: "https://widget-instant.ramp.network/")
            configuration.userAddress = address
            configuration.swapAsset = param["symbol"] as? String
//            configuration.fiatValue = "2"
//            configuration.swapAsset = "BTC"
//            configuration.finalUrl = "rampexample://ramp.purchase.complete"
            let rampWidgetUrl = configuration.composeUrl()
            
            let rampVC = SFSafariViewController(url: rampWidgetUrl)
            rampVC.modalPresentationStyle = .overFullScreen
            self.present(rampVC, animated: true)
            
            
            
        }) {
            (error) in
            let alert = Alert.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
    func actionOnramp(param: NSDictionary) {
        RequestHandler.coinDeposit(parameter: param, success: {(successResponse) in
            let dictionary = successResponse as! [String: Any]
            
            var address = dictionary["address"] as! String
            let symbol = param["symbol"] as! String
            let excludeCryptos = "&excludeCryptos=EOS,USDT,XLM,BUSD,GUSD,HUSD,PAX,USDS"
            let coin_address = "&defaultAddrs=" + symbol + ":" + address
            let url = "https://widget.onramper.com?color=1d2d50&apiKey=\(self.onramperApiKey!)&defaultCrypto=\(symbol)\(excludeCryptos)\(coin_address)&onlyCryptos=\(self.onRamperCoins)&isAddressEditable=false"
            
            let webviewController = self.storyboard?.instantiateViewController(withIdentifier: "webVC") as! webVC
            webviewController.url = url
            self.navigationController?.pushViewController(webviewController, animated: true)
            
        }) {
            (error) in
            let alert = Alert.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
   
}
 
extension CoinsController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coinList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 130
        }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CoinView = tableView.dequeueReusableCell(withIdentifier: "CoinView", for: indexPath) as! CoinView
        cell.delegate = self
        let coin = coinList[indexPath.row]
        cell.lbName.text = coin.name
        cell.imgIcon.load(url: URL(string: coin.icon)!)
        cell.lbPrice.text = coin.price
        cell.lbHolding.text = coin.holding
        cell.lbBalance.text = "\(coin.balance!) \(coin.symbol!)"
        cell.lbChangePercent.text = "\(coin.changeToday!) %"
        cell.buyType = coin.buyType
        if coin.buyType == 0 || coin.buyType == 100 {
            cell.btnBuy.isHidden = true
        }
        if coin.changeToday >= 0 {
            cell.lbChangePercent.textColor = UIColor.green
            cell.imgChange.image = UIImage(named: "ic_up")
        } else {
            cell.lbChangePercent.textColor = UIColor.red
            cell.imgChange.image = UIImage(named: "ic_down")
        }
        
        cell.symbol = coin.symbol
        cell.id = coin.id ?? "0"
        
        
        return cell
    }
}

extension CoinsController: CoinViewParameterDelegate {
    func tradeParamData(param: NSDictionary) {
//        let cointradecontroller: CoinTradeOptionModal = self.storyboard?.instantiateViewController(withIdentifier: "CoinTradeOptionModal") as! CoinTradeOptionModal
//        let popup = PopupDialog(viewController: cointradecontroller,
//                                buttonAlignment: .horizontal,
//                                transitionStyle: .bounceDown,
//                                tapGestureDismissal: true,
//                                panGestureDismissal: true)
//        let buttonTwo = DefaultButton(title: "Select", height: 30) {
//                    print("here")
//                }
//        popup.addButton(buttonTwo)
//
////        let overlayAppearance = PopupDialogOverlayView.appearance()
////        overlayAppearance.opacity = 0.3
//
//        self.presentVC(popup)
        
        let alertController = UIAlertController(title: "Buy / Sell", message: "Select option to buy cryptocurrencies with over 40 fiat currencies", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Buy / Sell \n (INR, MYR, HKD, PHP, TBH, VND, SGD, RP) \n Powered by xanpool", style: .default) { (_) in
            self.actionXanpool(param: param)
        }
        let action2 = UIAlertAction(title: "Buy only(USD, EUR) \n Powered by Ramp", style: .default) { action in
            self.actionRamp(param: param)
        }
        let action3 = UIAlertAction(title: "Buy only(Global) \n Powered by onramp", style: .default) { action in
            self.actionOnramp(param: param)
        }
        if (param["buyType"] as! Int) > 1 {
            alertController.addAction(action1)
        }
        alertController.addAction(action2)
        if (param["buyType"] as! Int) > 2 {
            alertController.addAction(action3)
        }
        
        UILabel.appearance(whenContainedInInstancesOf:[UIAlertController.self]).numberOfLines = 3
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        self.presentVC(alertController);
    }
    
    func depositParamData(param: NSDictionary) {
        
        RequestHandler.coinDeposit(parameter: param, success: {(successResponse) in
            let dictionary = successResponse as! [String: Any]
            
            var address = dictionary["address"] as! String
            let alertController = UIAlertController(title: "Only send \(param["symbol"]!)", message: nil, preferredStyle: .alert)
            let copyAction = UIAlertAction(title: "Copy", style: .default) { (_) in
                let pasteboard = UIPasteboard.general
                pasteboard.string = address
                self.showToast(message: "Copied successfully")
            }
            
            alertController.addTextField { (textField) in
                textField.text = address
            }
            alertController.addAction(copyAction)
            
            self.present(alertController, animated: true, completion: nil)
        
        }) {
            (error) in
            let alert = Alert.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
}
