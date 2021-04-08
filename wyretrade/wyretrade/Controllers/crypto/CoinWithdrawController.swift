//
//  CoinWithdrawController.swift
//  wyretrade
//
//  Created by maxus on 3/5/21.
//

import Foundation
import UIKit
import stellarsdk

class CoinWithdrawController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var txtAmount: UITextField! {
        didSet {
            txtAmount.delegate = self
        }
    }
    @IBOutlet weak var lbBalance: UILabel!
    @IBOutlet weak var txtAddress: UITextField! {
        didSet {
            txtAddress.delegate = self
        }
    }
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var btnCoin: UIButton! {
        didSet{
            btnCoin.semanticContentAttribute = .forceRightToLeft
        }
    }
    
    @IBOutlet weak var lbFee: UILabel!
    @IBOutlet weak var lbEstGet: UILabel!
    @IBOutlet weak var historyTable: UITableView! {
        didSet {
                    historyTable.delegate = self
                    historyTable.dataSource = self
                    historyTable.showsVerticalScrollIndicator = false
                    historyTable.separatorColor = UIColor.darkGray
                    historyTable.separatorStyle = .singleLineEtched
                    historyTable.register(UINib(nibName: "CoinWithdrawItem", bundle: nil), forCellReuseIdentifier: "CoinWithdrawItem")
                }
    }
    
    var historyList = [CoinWithdrawModel]()
    var coinList = [CoinModel]()
    var selectedCoin: CoinModel!
    var withdrawFee = 0.0
    var symbol = "BTC"
    var coinId = "1"
    var balance = 0.0
    var stellarBaseSecret: String!
    
    let sdk = StellarSDK(withHorizonUrl: "https://horizon.stellar.org")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.addLeftBarButtonWithImage(UIImage(named: "ic_menu")!)
        // Do any additional setup after loading the view.
        txtAmount.addTarget(self, action: #selector(CoinWithdrawController.amountTextFiledDidChange), for: .editingChanged)
        
        self.loadData()
    }
    
    
    @objc func amountTextFiledDidChange(_ textField: UITextField) {
        guard let amount = textField.text else {
            return
        }
        
        if  amount == "" {
            return
        }
        
        let est: Double = Double(amount)! - self.withdrawFee
        
        self.lbEstGet.text = "\(est)"
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let next = segue.destination as! CoinSelectController
//        next.delegate = self
//    }
    
    func loadData() {
            let param : [String : Any] = [:]
            RequestHandler.getCoinWithdrawList(parameter: param as NSDictionary, success: { (successResponse) in
    //                        self.stopAnimating()
                let dictionary = successResponse as! [String: Any]
                
                var history : CoinWithdrawModel!
                
                if let historyData = dictionary["history"] as? [[String:Any]] {
                    self.historyList = [CoinWithdrawModel]()
                    for item in historyData {
                        history = CoinWithdrawModel(fromDictionary: item)
                        self.historyList.append(history)
                    }
                    self.historyTable.reloadData()
                }
                
                }) { (error) in
                    let alert = Alert.showBasicAlert(message: error.message)
                            self.presentVC(alert)
                }
        }
    
    func submitWithdraw(param: NSDictionary) {
        RequestHandler.coinWithdraw(parameter: param as NSDictionary, success: { (successResponse) in
//                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            let success: Bool = dictionary["success"] as! Bool
            
            if success {
                var history : CoinWithdrawModel!
                
                if let historyData = dictionary["history"] as? [[String:Any]] {
                    self.historyList = [CoinWithdrawModel]()
                    for item in historyData {
                        history = CoinWithdrawModel(fromDictionary: item)
                        self.historyList.append(history)
                    }
                    self.historyTable.reloadData()
                }
                var result: String!
                if let resultTemp = dictionary["result"] as? NSString {
                    result = NumberFormat(value: resultTemp.doubleValue, decimal: 6).description
                } else {
                    result = NumberFormat(value: dictionary["result"] as! Double, decimal: 6).description
                }
                self.balance = Double(result)!
                self.lbBalance.text = result
                
                self.showToast(message: dictionary["message"] as! String)
            } else {
                let alert = Alert.showBasicAlert(message: dictionary["message"] as! String)
                        self.presentVC(alert)
            }
            
            
            
            }) { (error) in
                let alert = Alert.showBasicAlert(message: error.message)
                        self.presentVC(alert)
            }
    }
    
    func sendStellar() {
        
        let address = txtAddress.text
        // destination account
        let destinationAccountKeyPair = try! KeyPair(accountId: address!)
        
        self.createStellarPayment(keyPair: destinationAccountKeyPair)
//        if self.selectedCoin.type == "Stellar" {
//            self.createStellarPayment(keyPair: destinationAccountKeyPair)
//        } else {
//            self.createTrustLineForDest(keyPair: destinationAccountKeyPair)
//        }
        
    }
    
    func createTrustLineForDest(keyPair: KeyPair) {
        let sourceAccountKeyPair = keyPair
        
        let issuer = try! KeyPair(accountId: "GAH2T6DSKIIWTDRVGTFSYDIVQTJG4ZVUTQ6COFRUWSVFHHUBU5UDT7DO")

        // load the source account from horizon to be sure that we have the current sequence number.
        sdk.accounts.getAccountDetails(accountId: sourceAccountKeyPair.accountId) { (response) -> (Void) in
            switch response {
                case .success(let accountResponse): // source account successfully loaded.
                    do {
                    // build a add trustline operation.
                        
                        
                        let changeTrust = ChangeTrustOperation(sourceAccountId: sourceAccountKeyPair.accountId, asset: Asset(type: AssetType.ASSET_TYPE_CREDIT_ALPHANUM4, code: self.selectedCoin.symbol, issuer: issuer)!)
                        // build a transaction that contains the create trustline operation.
                        let transaction = try Transaction(sourceAccount: accountResponse,
                                        operations: [changeTrust],
                                        memo: Memo.none,
                                        timeBounds:nil)

                        // sign the transaction.
                        try! transaction.sign(keyPair: sourceAccountKeyPair, network: .public)

                            // submit the transaction to the stellar network.
                        try self.sdk.transactions.submitTransaction(transaction: transaction) { (response) -> (Void) in
                            switch response {
                                case .success(_):
                                    print("Created trustline successfully.")
                                    self.createTrustLineForDest(keyPair: keyPair)
                                case .failure(let error):
                                    StellarSDKLog.printHorizonRequestErrorMessage(tag:"Create trustline error", horizonRequestError: error)
                                default:
                                    print("stellar trustline no data")
                            }
                        }
                    } catch {
                        // ...
                        print("create stellar trustline exception")
                    }
                case .failure(let error): // error loading account details
                        StellarSDKLog.printHorizonRequestErrorMessage(tag:"Account detail Error:", horizonRequestError: error)
                }
        }
    }
    
    func createStellarPayment(keyPair: KeyPair) {
        let amount = txtAmount.text
        
        let issuer = try! KeyPair(accountId: "GAH2T6DSKIIWTDRVGTFSYDIVQTJG4ZVUTQ6COFRUWSVFHHUBU5UDT7DO")
        
        let sourceAccountKeyPair = try! KeyPair(secretSeed: self.selectedCoin.secretSeed)
        let destinationAccountKeyPair = keyPair
        
        sdk.accounts.getAccountDetails(accountId: sourceAccountKeyPair.accountId) { (response) -> (Void) in
            switch response {
                case .success(let accountResponse):
                    
                do {
                    
                    var transaction: Transaction!
                    
                    if self.selectedCoin.type == "Stellar" {
                        
                        let paymentOperation = try PaymentOperation(sourceAccountId: sourceAccountKeyPair.accountId, destinationAccountId: destinationAccountKeyPair.accountId, asset: Asset(type: AssetType.ASSET_TYPE_NATIVE)!, amount: Decimal(string: amount!)!)
                        
                        transaction = try Transaction(sourceAccount: accountResponse,
                                                          operations: [paymentOperation],
                                                          memo: Memo.none,
                                                          timeBounds:nil)
                    } else {
                        
                        let paymentOperation = try PaymentOperation(sourceAccountId: sourceAccountKeyPair.accountId, destinationAccountId: destinationAccountKeyPair.accountId, asset: Asset(type: AssetType.ASSET_TYPE_CREDIT_ALPHANUM4, code: self.selectedCoin.symbol!, issuer: issuer)!, amount: Decimal(string: amount!)!)
                        
                        transaction = try Transaction(sourceAccount: accountResponse,
                                                          operations: [paymentOperation],
                                                          memo: Memo.none,
                                                          timeBounds:nil)
                    }
                    
                    // sign the transaction
                    try transaction.sign(keyPair: sourceAccountKeyPair, network: .public)
                    print("passed sign")
                    // submit the transaction.
                    try self.sdk.transactions.submitTransaction(transaction: transaction) { (response) -> (Void) in
                        switch response {
                        case .success(_):
                            print("stellar withdraw Success")
                            let param = [
                                "coin_id": self.coinId,
                                "amount": amount,
                                "address": destinationAccountKeyPair.accountId
                            ] as! NSDictionary
                            self.submitWithdraw(param: param)
                        case .failure(let error):
                            StellarSDKLog.printHorizonRequestErrorMessage(tag:"stellar withdraw fail", horizonRequestError:error)
                        default:
                            print("stellar withdraw no data")
                        }
                    }
                } catch {
                    print("here catch")
                    //...
                }
                case .failure(let error):
                    StellarSDKLog.printHorizonRequestErrorMessage(tag:"SRP Test", horizonRequestError:error)
            }
        }
    }

    @IBAction func actionWithdraw(_ sender: Any) {
        guard let amount = txtAmount.text else {
            return
        }
        guard let address = txtAddress.text else {
            return
        }
        if amount == "" {
            txtAmount.shake(6, withDelta:10, speed: 0.06)
            return
        }
        if address == "" {
            txtAddress.shake(6, withDelta:10, speed: 0.06)
            return
        }
        
        if Double(amount)! > balance {
            self.showToast(message: "Insufficient balance")
            return
        }
        
        let param = [
            "coin_id": coinId,
            "amount": amount,
            "address": address
        ] as! NSDictionary
        
        let alert = Alert.showConfirmAlert(message: "Are you sure withdraw \(amount) \(symbol) to \(address) ?", handler: {
            (_) in
            if self.selectedCoin != nil {
                if self.selectedCoin.type == "Token" || self.selectedCoin.type == "Stellar" {
                    self.sendStellar()
                } else {
                    self.submitWithdraw(param: param)
                }
            } else {
                self.submitWithdraw(param: param)
            }
        })
        self.presentVC(alert)
    }
    
    @IBAction func actionSelectCoin(_ sender: Any) {
        let param : [String : Any] = [:]
        RequestHandler.getCoinWithdrawableAssets(parameter: param as NSDictionary, success: { (successResponse) in
//                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            var coin : CoinModel!
            
            if let Data = dictionary["assets"] as? [[String:Any]] {
                self.coinList = [CoinModel]()
                for item in Data {
                    coin = CoinModel(fromDictionary: item)
                    self.coinList.append(coin)
                }
                
                let detailController = self.storyboard?.instantiateViewController(withIdentifier: "CoinSelectController") as! CoinSelectController
                detailController.delegate = self
                detailController.coinList = self.coinList
                self.navigationController?.pushViewController(detailController, animated: true)
            }
            
            }) { (error) in
                let alert = Alert.showBasicAlert(message: error.message)
                        self.presentVC(alert)
            }
        
    }
    
    
}

extension CoinWithdrawController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CoinWithdrawItem = tableView.dequeueReusableCell(withIdentifier: "CoinWithdrawItem", for: indexPath) as! CoinWithdrawItem
        let item = historyList[indexPath.row]
        cell.lbAsset.text = item.symbol
        cell.lbAmount.text = item.amount
        cell.lbStatus.text = item.status
        cell.lbDate.text = item.date
        cell.lbAddress.text = item.address

        return cell
    }
}

extension CoinWithdrawController: CoinSelectControllerDelegate {
    func selectCoin(param: CoinModel) {
        self.selectedCoin = param
        self.lbBalance.text = param.balance
        self.balance = Double(param.balance)!
        self.imgIcon.load(url: URL(string: param.icon)!)
        self.btnCoin.setTitle(param.symbol!, for: .normal)
        self.lbFee.text = "\(param.withdrawFee!)"
        self.symbol = param.symbol
        self.withdrawFee = param.withdrawFee
        self.coinId = param.id
    }
}
