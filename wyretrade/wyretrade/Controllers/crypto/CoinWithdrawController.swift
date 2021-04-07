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
        
        var est: Double = Double(amount)! - self.withdrawFee
        
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
            
            var success: Bool = dictionary["success"] as! Bool
            
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
                
                let result = dictionary["result"] as! String
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
        let sdk = StellarSDK(withHorizonUrl: "https://horizon.stellar.org")
//        let sourceAccountKeyPair = try! KeyPair(secretSeed: self.selectedCoin.secretSeed)
        let sourceAccountKeyPair = try! KeyPair(secretSeed:"SAQLGANA5JIN7SXOBGO4UB53XDBI7K2SCFKIOLAN3LVUIGE7W6RBYS34")
//        GBX45RRD5XKFNBPSQEA44VMP75Q34QQLIF53M5S3PWFFZVV6ID6TIHXU
        let address = txtAddress.text
        // destination account
        let destinationAccountKeyPair = try! KeyPair(accountId: address!)
        let amount = txtAmount.text
        
        print("Source account Id: " + sourceAccountKeyPair.accountId)
        
        
        print("Destination account Id: " + destinationAccountKeyPair.accountId)
//        print("Destination secret seed: " + destinationAccountKeyPair.secretSeed)
        
        sdk.accounts.getAccountDetails(accountId: address!) { (response) -> (Void) in
            switch response {
            case .success(_):
                
                sdk.accounts.getAccountDetails(accountId: self.selectedCoin.address) { (response) -> (Void) in
                    switch response {
                        case .success(let accountResponse):
                            
                        do {
                            
                            
//                            let paymentOperation = PaymentOperation(destination: destinationAccountKeyPair,
//                                                                    asset: Asset(type: type)!,
//                                                                    amount: Decimal(string: amount!)!)
                            var paymentOperation = try PaymentOperation(sourceAccountId: self.selectedCoin.address, destinationAccountId: address!, asset: Asset(type: AssetType.ASSET_TYPE_NATIVE)!, amount: Decimal(string: amount!)!)
                            if self.selectedCoin.type != "Stellar" {
//
                                paymentOperation = try PaymentOperation(sourceAccountId: self.selectedCoin.address, destinationAccountId: address!, asset: Asset(type: AssetType.ASSET_TYPE_CREDIT_ALPHANUM4, code: self.selectedCoin.symbol!, issuer: sourceAccountKeyPair)!, amount: Decimal(string: amount!)!)
                            }
                            print("created payment operation")
                            // build the transaction containing our payment operation.
                            let transaction = try Transaction(sourceAccount: accountResponse,
                                                              operations: [paymentOperation],
                                                              memo: Memo.none,
                                                              timeBounds:nil)
                            print("created payment transaction")
                            // sign the transaction
                            try transaction.sign(keyPair: sourceAccountKeyPair, network: .public)
                            print("passed sign")
                            // submit the transaction.
                            try sdk.transactions.submitTransaction(transaction: transaction) { (response) -> (Void) in
                                switch response {
                                case .success(_):
                                    print("stellar withdraw Success")
                                    let param = [
                                        "coin_id": self.coinId,
                                        "amount": amount,
                                        "address": address
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
            case .failure(let error):
                StellarSDKLog.printHorizonRequestErrorMessage(tag: "Destination account error", horizonRequestError: error)
            }
        }
        
        // get the account data to be sure that we have the current sequence number.
        
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
