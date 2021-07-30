//
//  CoinWithdrawController.swift
//  wyretrade
//
//  Created by maxus on 3/5/21.
//

import Foundation
import UIKit
import stellarsdk
import NVActivityIndicatorView
import PhoneNumberKit
import FirebaseAuth

class CoinWithdrawController: UIViewController, UITextFieldDelegate, NVActivityIndicatorViewable {
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
    
    
    @IBOutlet weak var lbWeeklyLimit: UILabel!
    
    
    @IBOutlet weak var lbGasFee: UILabel!
    @IBOutlet weak var lbFee: UILabel!
    @IBOutlet weak var lbEstGet: UILabel!
    
    @IBOutlet weak var btnWithdraw: UIButton! {
        didSet {
            btnWithdraw.round()
        }
    }
    @IBOutlet weak var btnHistory: UIButton! {
        didSet {
            btnHistory.round()
        }
    }
    
    
    
    var coinList = [CoinModel]()
    var selectedCoin: CoinModel!
    var withdrawFee = 0.0
    var symbol = "BTC"
    var coinId = "1"
    var balance = 0.0
    var sendingAmount = 0.0
    var stellarBaseSecret: String!
    var ethGas: String!
    var bscGas: String!
    
    let sdk = StellarSDK(withHorizonUrl: "https://horizon.stellar.org")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.addLeftBarButtonWithImage(UIImage(named: "ic_menu")!)
        // Do any additional setup after loading the view.
        txtAmount.addTarget(self, action: #selector(CoinWithdrawController.amountTextFiledDidChange), for: .editingChanged)
        
        self.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.loadData()
    }
    
    
    @objc func amountTextFiledDidChange(_ textField: UITextField) {
        guard let amount = textField.text else {
            return
        }
        
        if  amount == "" {
            self.sendingAmount = 0.0
            return
        }
        
        self.sendingAmount = Double(amount)!
        self.displayEstGet()
    }
    
    func displayEstGet() {
        var est: Double!
        if self.coinId == "0" {
            est = self.sendingAmount
        } else {
            est = self.sendingAmount  - self.withdrawFee
        }
        if self.sendingAmount == 0 {
            est = 0.0
        }
        self.lbEstGet.text = NumberFormat(value: est, decimal: 6).description
        
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let next = segue.destination as! CoinSelectController
//        next.delegate = self
//    }
    
    func loadData() {
            let param : [String : Any] = [:]
        self.startAnimating()
            RequestHandler.getCoinWithdrawList(parameter: param as NSDictionary, success: { (successResponse) in
                            self.stopAnimating()
                let dictionary = successResponse as! [String: Any]
                
                self.lbWeeklyLimit.text = "Weekly withdrawal limit =  $\(dictionary["weekly_withdraw_limit"]!)"
                self.ethGas = "\(dictionary["eth_gas"]!)ETH"
                self.bscGas = "\(dictionary["bsc_gas"]!)BNB(BSC)"
                self.selectedCoin = CoinModel(fromDictionary: dictionary["coin"] as! [String : Any])
                
                self.symbol = self.selectedCoin.symbol
                self.coinId = self.selectedCoin.id
                self.lbBalance.text = self.selectedCoin.balance
                self.balance = Double(self.selectedCoin.balance)!
                self.imgIcon.load(url: URL(string: self.selectedCoin.icon)!)
                self.btnCoin.setTitle(self.selectedCoin.symbol!, for: .normal)
                if self.coinId == "0" {
                    self.lbFee.text = NumberFormat(value: self.selectedCoin.withdrawFee, decimal: 4).description + "BNB(BSC)"
                } else {
                    self.lbFee.text = NumberFormat(value: self.selectedCoin.withdrawFee, decimal: 4).description + self.symbol
                }
                self.withdrawFee = self.selectedCoin.withdrawFee
                
                if self.selectedCoin.type == "ERC20" {
                    self.lbGasFee.text = self.ethGas + "ETH"
                } else if self.selectedCoin.type == "BEP20" {
                    self.lbGasFee.text = self.bscGas + "BNB(BSC)"
                }
                else {
                    self.lbGasFee.text = "0"
                }
                
                }) { (error) in
                        self.stopAnimating()
                    let alert = Alert.showBasicAlert(message: error.message)
                            self.presentVC(alert)
                }
        }
    
    func submitWithdraw(param: NSDictionary) {
        self.startAnimating()
        RequestHandler.coinWithdraw(parameter: param as NSDictionary, success: { (successResponse) in
                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            let success: Bool = dictionary["success"] as! Bool
            
            if success {
                
                var result: String!
                if let resultTemp = dictionary["result"] as? NSString {
                    result = NumberFormat(value: resultTemp.doubleValue, decimal: 6).description
                } else {
                    result = NumberFormat(value: dictionary["result"] as! Double, decimal: 6).description
                }
                self.balance = Double(result)!
                self.lbBalance.text = result
                
                self.showToast(message: dictionary["message"] as! String)
                
                self.completeWithdraw()
            } else {
                let alert = Alert.showBasicAlert(message: dictionary["message"] as! String)
                        self.presentVC(alert)
            }
            
            
            
            }) { (error) in
                        self.stopAnimating()
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
        self.startAnimating()
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
                            self.stopAnimating()
                        default:
                            print("stellar withdraw no data")
                        }
                    }
                } catch {
                    print("stellarwithdraw catch")
                    self.stopAnimating()
                    //...
                }
                case .failure(let error):
                    StellarSDKLog.printHorizonRequestErrorMessage(tag:"SRP Test", horizonRequestError:error)
                    self.stopAnimating()
            }
        }
    }
    
    func showPhoneAlert() {
        let phoneNumberKit = PhoneNumberKit()
//        phoneNumberKit.allCountries()
        
        let alertController = UIAlertController(title: "Phone Verify", message: "", preferredStyle: .alert)
        
        let containerViewWidth = 250
            let containerViewHeight = 120
            let containerFrame = CGRect(x:10, y: 70, width: CGFloat(containerViewWidth), height: CGFloat(containerViewHeight));
            let containerView: UIView = UIView(frame: containerFrame);

        alertController.view.addSubview(containerView)

            // now add some constraints to make sure that the alert resizes itself
            let cons:NSLayoutConstraint = NSLayoutConstraint(item: alertController.view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.greaterThanOrEqual, toItem: containerView, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1.00, constant: 130)

        alertController.view.addConstraint(cons)

            let cons2:NSLayoutConstraint = NSLayoutConstraint(item: alertController.view, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.greaterThanOrEqual, toItem: containerView, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1.00, constant: 20)

        alertController.view.addConstraint(cons2)
//
        let phoneTextFiled = PhoneNumberTextField()
        phoneTextFiled.delegate = self
        phoneTextFiled.withFlag = true
        phoneTextFiled.withPrefix = true
        phoneTextFiled.withExamplePlaceholder = true
//        phoneTextFiled.becomeFirstResponder()
        phoneTextFiled.withDefaultPickerUI = true
        alertController.view.addSubview(phoneTextFiled)
        
        
        
        phoneTextFiled.translatesAutoresizingMaskIntoConstraints = false
        phoneTextFiled.centerXAnchor.constraint(equalTo: alertController.view.centerXAnchor).isActive = true
        phoneTextFiled.centerYAnchor.constraint(equalTo: alertController.view.centerYAnchor).isActive = true
        phoneTextFiled.widthAnchor.constraint(equalToConstant: 200.0)
        phoneTextFiled.heightAnchor.constraint(equalToConstant: 50.0)
//        phoneTextFiled.widthAnchor.constraint(equalTo: alertController.view.widthAnchor).isActive = true
//        phoneTextFiled.heightAnchor.constraint(equalTo: alertController.view.heightAnchor).isActive = true
        
        let action = UIAlertAction(title: "Send", style: .default) { (_) in
            do {
//                let textField1 = alertController.textFields?.first as! UITextField
                let phone = phoneTextFiled.text!
                if phone != "" {
                    let phoneNumber = try phoneNumberKit.parse(phone)
                    phoneNumberKit.format(phoneNumber, toType: .e164, withPrefix: true)
                    print(phoneNumber.numberString)
                    print(phoneNumber.countryCode)
                    print(phoneNumber.nationalNumber)
                    print(phoneNumber.numberExtension)
                    print(phoneNumber.type)
                }
            } catch {
                print("phone exception")
            }
        }
        alertController.addAction(action)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        self.presentVC(alertController);
    }
    
    func completeWithdraw() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "CompleteWithdrawController") as! CompleteWithdrawController
        if self.selectedCoin != nil {
            vc.icon = self.selectedCoin.icon
            vc.symbol = self.selectedCoin.symbol
        }
        vc.amount = self.txtAmount.text
        vc.address = self.txtAddress.text
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionHistory(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "CoinWithdrawHistoryController") as! CoinWithdrawHistoryController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    @IBAction func actionWithdraw(_ sender: Any) {

        guard let address = txtAddress.text else {
            return
        }
        if self.sendingAmount == 0 {
            txtAmount.shake(6, withDelta:10, speed: 0.06)
            return
        }
        if address == "" {
            txtAddress.shake(6, withDelta:10, speed: 0.06)
            return
        }
        
        if self.sendingAmount > balance {
            self.showToast(message: "Insufficient balance")
            return
        }
        
        let param = [
            "coin_id": coinId,
            "amount": self.txtAmount.text!,
            "address": self.txtAddress.text!
        ] as! NSDictionary
        
        let defaults = UserDefaults.init()
        
        let alert = Alert.showConfirmAlert(message: "Are you sure withdraw \(self.sendingAmount) \(symbol) to \(address) ? \(defaults.string(forKey: "msgCoinWithdrawFeePolicy")!)", handler: {
            (_) in
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerifyPhoneNumberController") as! VerifyPhoneNumberController
//            vc.delegate = self
//            self.navigationController?.pushViewController(vc, animated: true)
            
            self.submitWithdraw(param: param)
            
        })
        self.presentVC(alert)
    }
    
    @IBAction func actionSelectCoin(_ sender: Any) {
        let param : [String : Any] = [:]
        self.startAnimating()
        RequestHandler.getCoinWithdrawableAssets(parameter: param as NSDictionary, success: { (successResponse) in
                        self.stopAnimating()
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
                        self.stopAnimating()
                let alert = Alert.showBasicAlert(message: error.message)
                        self.presentVC(alert)
            }
        
    }
    
    
}

extension CoinWithdrawController: CoinSelectControllerDelegate {
    func selectCoin(param: CoinModel) {
        self.selectedCoin = param
        self.lbBalance.text = param.balance
        self.balance = Double(param.balance)!
        self.imgIcon.load(url: URL(string: param.icon)!)
        self.btnCoin.setTitle(param.symbol!, for: .normal)
        
        self.symbol = param.symbol
        self.withdrawFee = param.withdrawFee
        self.coinId = param.id
        self.displayEstGet()
        if self.coinId == "0" {
            self.lbFee.text = NumberFormat(value: self.selectedCoin.withdrawFee, decimal: 4).description + "BNB(BSC)"
        } else {
            self.lbFee.text = NumberFormat(value: self.selectedCoin.withdrawFee, decimal: 4).description + self.symbol
        }
        if self.selectedCoin.type == "ERC20" {
            self.lbGasFee.text = self.ethGas + "ETH"
        } else if self.selectedCoin.type == "BEP20" {
            self.lbGasFee.text = self.bscGas + "BNB(BSC)"
        }
        else {
            self.lbGasFee.text = "0"
        }
    }
    
}

extension CoinWithdrawController: VerifyCodeControllerDelegate {
    func passVerify() {
        let param = [
            "coin_id": coinId,
            "amount": self.txtAmount.text!,
            "address": self.txtAddress.text!
        ] as! NSDictionary
        
//        if self.selectedCoin != nil {
//            if self.selectedCoin.type == "Token" || self.selectedCoin.type == "Stellar" {
//                self.sendStellar()
//            } else {
//                self.submitWithdraw(param: param)
//            }
//        } else {
//            self.submitWithdraw(param: param)
//        }
        self.submitWithdraw(param: param)
        
    }
}
