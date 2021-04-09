//
//  CoinsController.swift
//  wyretrade
//
//  Created by maxus on 3/1/21.
//

import UIKit
import SafariServices
import stellarsdk
import NVActivityIndicatorView

class CoinsController: UIViewController, NVActivityIndicatorViewable {
    
    
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
    var depositList = [CoinModel]()
    var onramperApiKey: String!
    var xanpoolApiKey: String!
    var onRamperCoins = ""
    var stellarBaseSecret: String!
    var stellarAccountId: String!
    
    let sdk = StellarSDK(withHorizonUrl: "https://horizon.stellar.org")
    
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
        RequestHandler.getCoins(parameter: param as NSDictionary, success: { (successResponse) in
                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            var coin : CoinModel!
            
            if let coinData = dictionary["coins"] as? [[String:Any]] {
                self.coinList = [CoinModel]()
                self.depositList = [CoinModel]()
                for item in coinData {
                    coin = CoinModel(fromDictionary: item)
                    self.coinList.append(coin)
//                    if coin.type != "Token" {
//
//                    }
                    self.depositList.append(coin)
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
            self.stellarBaseSecret = dictionary["stellar_base_secret"] as? String
            self.stellarAccountId = dictionary["stellar_account_id"] as? String
            if self.stellarAccountId != "" {
                self.stellarStreamForPayment()
            }
                
            }) { (error) in
                        self.stopAnimating()
                let alert = Alert.showBasicAlert(message: error.message)
                        self.presentVC(alert)
            }
    }
    
    func actionXanpool(param: NSDictionary) {
        self.startAnimating()
        RequestHandler.coinDeposit(parameter: param, success: {(successResponse) in
            self.stopAnimating()
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
                        self.stopAnimating()
            let alert = Alert.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
    func actionRamp(param: NSDictionary) {
        self.startAnimating()
        RequestHandler.coinDeposit(parameter: param, success: {(successResponse) in
            self.stopAnimating()
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
                        self.stopAnimating()
            let alert = Alert.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
    func actionOnramp(param: NSDictionary) {
        self.startAnimating()
        RequestHandler.coinDeposit(parameter: param, success: {(successResponse) in
            self.stopAnimating()
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
                        self.stopAnimating()
            let alert = Alert.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
    func showAddressAlert(symbol : String, address: String) {
        let alertController = UIAlertController(title: "Send \(symbol) only this address", message: nil, preferredStyle: .alert)
        let copyAction = UIAlertAction(title: "Copy", style: .default) { (_) in
            let pasteboard = UIPasteboard.general
            pasteboard.string = address
            self.showToast(message: "Copied successfully")
        }
        
        alertController.addTextField { (textField) in
            textField.text = address
        }
        alertController.addAction(copyAction)
        
//            let constraintWidth = NSLayoutConstraint(
//                  item: alertController.view!, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute:
//                  NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 400)
//            alertController.view.addConstraint(constraintWidth)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func generateStellarAddress(param: CoinModel) {
        
        
//        let sourceAccountKeyPair = try! KeyPair(secretSeed:"SAQLGANA5JIN7SXOBGO4UB53XDBI7K2SCFKIOLAN3LVUIGE7W6RBYS34")
        let sourceAccountKeyPair = try! KeyPair(secretSeed: self.stellarBaseSecret)
//        let sourceAccountKeyPair = try! KeyPair(accountId: "GCRR74O62OV7E7WJSIEIWRKGBIDYNPBMN72QPIL6ZCNQ37VJELC6VG5E")
        print("Source account Id: " + sourceAccountKeyPair.accountId)
        // generate a random keypair representing the new account to be created.
        let destinationKeyPair = try! KeyPair.generateRandomKeyPair()
        print("Destination account Id: " + destinationKeyPair.accountId)
        print("Destination secret seed: " + destinationKeyPair.secretSeed)
        
        // load the source account from horizon to be sure that we have the current sequence number.
        self.startAnimating()
        self.sdk.accounts.getAccountDetails(accountId: sourceAccountKeyPair.accountId) { (response) -> (Void) in
            self.stopAnimating()
            switch response {
                case .success(let accountResponse): // source account successfully loaded.
                    do {
                    // build a create account operation.
                        let createAccount = CreateAccountOperation(sourceAccountId: sourceAccountKeyPair.accountId, destination: destinationKeyPair, startBalance: 1.0)
                        

                        // build a transaction that contains the create account operation.
                    let transaction = try Transaction(sourceAccount: accountResponse,
                                        operations: [createAccount],
                                        memo: Memo.none,
                                        timeBounds:nil)

                    // sign the transaction.
                    try! transaction.sign(keyPair: sourceAccountKeyPair, network: .public)

                        // submit the transaction to the stellar network.
                    try self.sdk.transactions.submitTransaction(transaction: transaction) { (response) -> (Void) in
                        switch response {
                        case .success(_):
                            print("Account successfully created.")
                            let parameter: NSDictionary = [
                                "coin": param.id!,
                                "symbol": param.symbol!,
                                "address": destinationKeyPair.accountId,
                                "stellar_secret": destinationKeyPair.secretSeed!
                            ]
                            self.submitDeposit(param: parameter)
                        case .failure(let error):
                            StellarSDKLog.printHorizonRequestErrorMessage(tag:"Create account error", horizonRequestError: error)
                        default:
                            print("stelalr depost no data")
                        }
                    }
                } catch {
                    // ...
                }
            case .failure(let error): // error loading account details
                    StellarSDKLog.printHorizonRequestErrorMessage(tag:"Account detail Error:", horizonRequestError: error)
            }
        }
        
//        self.sdk.accounts.createTestAccount(accountId: destinationKeyPair.accountId) { (response) -> (Void) in
//            switch response {
//            case .success(let details):
//                print(details)
//                let parameter: NSDictionary = [
//                    "coin": param.id!,
//                    "symbol": param.symbol!,
//                    "address": destinationKeyPair.accountId
//                ]
//                self.submitDeposit(param: parameter)
//            case .failure(let error):
//                StellarSDKLog.printHorizonRequestErrorMessage(tag:"Error:", horizonRequestError: error)
//            }
//        }
    }
    
    func stellarStreamForPayment() {
        print("stellar stream \(self.stellarAccountId!)")
        sdk.payments.stream(for: .paymentsForAccount(account: self.stellarAccountId, cursor: "now")).onReceive { (response) -> (Void) in
            print("stellar stream start")
            switch response {
            case .open:
                print("stellar stream open")
                break
            case .response(let id, let operationResponse):
                if let paymentResponse = operationResponse as? PaymentOperationResponse {
                    switch paymentResponse.assetType {
                    case AssetTypeAsString.NATIVE:
                        print("Payment of \(paymentResponse.amount) XLM from \(paymentResponse.sourceAccount) received -  id \(id)" )
                        let param : NSDictionary = [
                            "coin": "XLM",
                            "amount": paymentResponse.amount
                        ]
                        self.submitStellarFunds(param: param)
                    case AssetTypeAsString.CREDIT_ALPHANUM4:
                        print("Payment of \(paymentResponse.amount) Asset from \(paymentResponse.sourceAccount) received -  id \(id)" )
                        
                        let param : NSDictionary = [
                            "coin": "PEPE", //paymentResponse.assetCode
                            "amount": paymentResponse.amount
                        ]
                        self.submitStellarFunds(param: param)
                    default:
                        print("Payment of \(paymentResponse.amount) \(paymentResponse.assetCode!) from \(paymentResponse.sourceAccount) received -  id \(id)" )
                    }
                    
                    
                }
            case .error(let error):
                if let horizonRequestError = error as? HorizonRequestError {
                    StellarSDKLog.printHorizonRequestErrorMessage(tag:"Receive payment", horizonRequestError:horizonRequestError)
                } else {
                    print("Error \(error?.localizedDescription ?? "")") // Other error like e.g. streaming error, you may want to ignore this.
                }
            }
        }
    }
    
    func submitStellarFunds(param: NSDictionary) {
        self.startAnimating()
        RequestHandler.coinStellarDeposit(parameter: param, success: {(successResponse) in
            self.stopAnimating()
//            let dictionary = successResponse as! [String: Any]
            print("deposited \(param["amount"]!) \(param["coin"]!)")
        }) {
            (error) in
                        self.stopAnimating()
            let alert = Alert.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
    func submitDeposit(param: NSDictionary) {
        self.startAnimating()
        RequestHandler.coinDeposit(parameter: param, success: {(successResponse) in
            self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            let address = dictionary["address"] as! String
            self.showAddressAlert(symbol: param["symbol"] as! String, address: address)
            
            
        }) {
            (error) in
                        self.stopAnimating()
            let alert = Alert.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
   
    @IBAction func actionDeposit(_ sender: Any) {
        let detailController = self.storyboard?.instantiateViewController(withIdentifier: "CoinSelectController") as! CoinSelectController
        detailController.delegate = self
        detailController.coinList = self.depositList
        self.navigationController?.pushViewController(detailController, animated: true)
    }
    
    @IBAction func actionBuy(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CoinTradePagerVC") as! CoinTradePagerVC
        vc.coinList = self.coinList
        vc.onRamperCoins = self.onRamperCoins
        vc.onramperApiKey = self.onramperApiKey
        vc.xanpoolApiKey = self.xanpoolApiKey
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionWithdraw(_ sender: Any) {
        let coinwithdrawView = storyboard?.instantiateViewController(withIdentifier: "CoinWithdrawController") as! CoinWithdrawController
        coinwithdrawView.stellarBaseSecret = self.stellarBaseSecret
        self.navigationController?.pushViewController(coinwithdrawView, animated: true)
    }
}
 
extension CoinsController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coinList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 60
        }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CoinView = tableView.dequeueReusableCell(withIdentifier: "CoinView", for: indexPath) as! CoinView
        cell.delegate = self
        let coin = coinList[indexPath.row]
        cell.lbName.text = coin.symbol
        cell.imgIcon.load(url: URL(string: coin.icon)!)
        cell.lbPrice.text = coin.price
        cell.lbHolding.text = coin.holding
        cell.lbBalance.text = "\(coin.balance!)"
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
        
        
    }
}

extension CoinsController: CoinSelectControllerDelegate {
    func selectCoin(param: CoinModel) {
        if param.address == "" {
            if param.type == "Token" || param.type == "Stellar" {
                self.generateStellarAddress(param: param)
            } else {
                let parameter: NSDictionary = [
                    "coin": param.id!,
                    "symbol": param.symbol!
                ]
                self.submitDeposit(param: parameter)
            }
            
        } else {
            
            self.showAddressAlert(symbol: param.symbol, address: param.address)
            
        }
        
    }
}
