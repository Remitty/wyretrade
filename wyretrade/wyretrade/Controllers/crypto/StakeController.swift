//
//  StakeController.swift
//  wyretrade
//
//  Created by maxus on 3/3/21.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import stellarsdk

class StakeController: UIViewController, UITextFieldDelegate, NVActivityIndicatorViewable {
    
    @IBOutlet weak var lbSymbol: UILabel!
    @IBOutlet weak var lbYearlyRewardPercent: UILabel!
    
    @IBOutlet weak var lbBalance: UILabel!
    @IBOutlet weak var lbStakingAmount: UILabel!
    @IBOutlet weak var lbDailyReward: UILabel!
    @IBOutlet weak var txtAmount: UITextField! {
        didSet {
            txtAmount.delegate = self
        }
    }
    
    @IBOutlet weak var btnStake: UIButton! {
        didSet {
            btnStake.roundCorners()
        }
    }

    @IBOutlet weak var btnUnstake: UIButton! {
        didSet {
            btnUnstake.roundCorners()
        }
    }

    @IBOutlet weak var btnHistory: UIButton! {
        didSet {
            btnHistory.round()
        }
    }
    
    @IBOutlet weak var lbSymbol2: UILabel!
    
    
    var historyList = [StakeModel]()
    var coin: StakeCoinModel!
    
    var stakingAmount = 0.0
    var symbol: String!
    var coinId: String!
    var coinBalance = 0.0
    
    var baseStellar: StellarAccount!
    var userStellar: StellarAccount!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        self.loadData()
        
        lbSymbol.text = self.coin.symbol
        lbSymbol2.text = self.coin.symbol
        
        self.symbol = self.coin.symbol
        self.coinId = self.coin.id
        self.lbBalance.text = self.coin.balance
        self.coinBalance = Double(self.coin.balance)!
        self.lbYearlyRewardPercent.text = "+" + self.coin.rewardYearlyPercent + "%"
  
        self.lbDailyReward.text = "+" + self.coin.dailyReward + " daily"
        self.lbStakingAmount.text = self.coin.staking
        self.stakingAmount = self.coin.dbStaking
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
//       self.navigationController?.isNavigationBarHidden = true
//        self.loadData()
   }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let next = segue.destination as! StakeHistoryController
        next.coin = self.symbol
    }
    
//    func loadData() {
//        self.startAnimating()
//        let param : [String : Any] = ["id": self.coinId]
//        RequestHandler.getStakeBalance(parameter: param as NSDictionary, success: { (successResponse) in
//                        self.stopAnimating()
//            let dictionary = successResponse as! [String: Any]
//
////            self.baseStellar = StellarAccount(fromDictionary: dictionary["base_stellar"] as! [String: Any])
////            self.userStellar = StellarAccount(fromDictionary: dictionary["user_stellar"] as! [String: Any])
//
//            var coin : StakeModel!
//
//            if let coinData = dictionary["stake_histories"] as? [[String:Any]] {
//                self.historyList = [StakeModel]()
//                for item in coinData {
//                    coin = StakeModel(fromDictionary: item)
//                    self.historyList.append(coin)
//                }
//                self.historyTable.reloadData()
//            }
//
//            if let coinBalanceTemp = (dictionary["coin_balance"] as? NSString)?.doubleValue {
//                self.coinBalance = (NumberFormat.init(value: coinBalanceTemp, decimal: 4).description as! NSString).doubleValue
//            } else {
//                self.coinBalance = (NumberFormat.init(value: dictionary["coin_balance"] as! Double, decimal: 4).description as! NSString).doubleValue
//            }
//
//            self.lbBalance.text = NumberFormat.init(value: self.coinBalance, decimal: 4).description
//
//            self.lbYearlyRewardPercent.text = "+" + NumberFormat(value: dictionary["yearly_fee"] as! Double, decimal: 4).description + "%"
//
//            if let daily = (dictionary["daily_reward"] as? NSString)?.doubleValue {
//                self.lbDailyReward.text = "+" + NumberFormat.init(value: daily, decimal: 4).description + " daily"
//            } else {
//                self.lbDailyReward.text = "+" + NumberFormat.init(value: dictionary["daily_reward"] as! Double, decimal: 4).description + " daily"
//            }
//
//            if let amount = (dictionary["stake_balance"] as? NSString)?.doubleValue {
//                self.lbStakingAmount.text = NumberFormat.init(value: amount, decimal: 4).description
//                self.stakingAmount = amount
//            } else {
//                self.lbStakingAmount.text = NumberFormat.init(value: dictionary["stake_balance"] as! Double, decimal: 4).description
//                self.stakingAmount = dictionary["stake_balance"] as! Double
//            }
//
//            }) { (error) in
//                        self.stopAnimating()
//                let alert = Alert.showBasicAlert(message: error.message)
//                        self.presentVC(alert)
//            }
//    }

    func sendStellar(param: NSDictionary, type: String) {
        let sdk = StellarSDK(withHorizonUrl: "https://horizon.stellar.org")
        var sourceAccountKeyPair: KeyPair!
        var destinationAccountKeyPair: KeyPair!
        if type == "stake" {
            sourceAccountKeyPair = try! KeyPair(secretSeed: self.userStellar.secret)
            destinationAccountKeyPair = try! KeyPair(accountId: self.baseStellar.accountId)
        } else {
            sourceAccountKeyPair = try! KeyPair(secretSeed: self.baseStellar.secret)
            destinationAccountKeyPair = try! KeyPair(accountId: self.userStellar.accountId)
        }
        let issuer = try! KeyPair(accountId: "GAH2T6DSKIIWTDRVGTFSYDIVQTJG4ZVUTQ6COFRUWSVFHHUBU5UDT7DO")
        
        let amount = param["amount"] as! String
        
        self.startAnimating()
        sdk.accounts.getAccountDetails(accountId: sourceAccountKeyPair.accountId) { (response) -> (Void) in
            
            switch response {
                case .success(let accountResponse):
                    
                do {
                    
                    var transaction: Transaction!
                    
                    if self.coin.type == "Stellar" {
                        
                        let paymentOperation = try PaymentOperation(sourceAccountId: sourceAccountKeyPair.accountId, destinationAccountId: destinationAccountKeyPair.accountId, asset: Asset(type: AssetType.ASSET_TYPE_NATIVE)!, amount: Decimal(string: amount)!)
                        
                        transaction = try Transaction(sourceAccount: accountResponse,
                                                          operations: [paymentOperation],
                                                          memo: Memo.none,
                                                          timeBounds:nil)
                    } else {
                        
                        let paymentOperation = try PaymentOperation(sourceAccountId: sourceAccountKeyPair.accountId, destinationAccountId: destinationAccountKeyPair.accountId, asset: Asset(type: AssetType.ASSET_TYPE_CREDIT_ALPHANUM4, code: self.coin.symbol!, issuer: issuer)!, amount: Decimal(string: amount)!)
                        
                        transaction = try Transaction(sourceAccount: accountResponse,
                                                          operations: [paymentOperation],
                                                          memo: Memo.none,
                                                          timeBounds:nil)
                    }
                    
                    // sign the transaction
                    try transaction.sign(keyPair: sourceAccountKeyPair, network: .public)
                    print("passed sign")
                    // submit the transaction.
                    try sdk.transactions.submitTransaction(transaction: transaction) { (response) -> (Void) in
                        switch response {
                        case .success(_):
                            print("stellar withdraw Success")
                            if type == "stake" {
                                self.submitStaking(param: param)
                            } else {
                                self.submitUnStaking(param: param)
                            }
                            
                        case .failure(let error):
                            StellarSDKLog.printHorizonRequestErrorMessage(tag:"stellar withdraw fail", horizonRequestError:error)
                            self.stopAnimating()
                        default:
                            print("stellar withdraw no data")
                        }
                    }
                } catch {
                    print("stellar withdraw catch")
                    self.stopAnimating()
                    //...
                }
                case .failure(let error):
                    StellarSDKLog.printHorizonRequestErrorMessage(tag:"SRP Test", horizonRequestError:error)
                    self.stopAnimating()
            }
        }
    }

    
    func submitStaking(param: NSDictionary) {
        self.startAnimating()
        RequestHandler.stake(parameter: param as NSDictionary, success: { (successResponse) in
                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            let success = dictionary["success"] as? Bool
            if success == true {
                var coin : StakeModel!
                
//                if let coinData = dictionary["stake_histories"] as? [[String:Any]] {
//                    self.historyList = [StakeModel]()
//                    for item in coinData {
//                        coin = StakeModel(fromDictionary: item)
//                        self.historyList.append(coin)
//                    }
//                    self.historyTable.reloadData()
//                }
                
                if let coinBalanceTemp = (dictionary["coin_balance"] as? NSString)?.doubleValue {
                    self.coinBalance = (NumberFormat.init(value: coinBalanceTemp, decimal: 4).description as! NSString).doubleValue
                } else {
                    self.coinBalance = (NumberFormat.init(value: dictionary["coin_balance"] as! Double, decimal: 4).description as! NSString).doubleValue
                }
                
                self.lbBalance.text = NumberFormat.init(value: self.coinBalance, decimal: 4).description
                
//                self.lbYearlyRewardPercent.text = "+\(dictionary["yearly_fee"]!)%"
                
                if let daily = (dictionary["daily_reward"] as? NSString)?.doubleValue {
                    self.lbDailyReward.text = "+" + NumberFormat.init(value: daily, decimal: 4).description + " daily"
                } else {
                    self.lbDailyReward.text = "+" + NumberFormat.init(value: dictionary["daily_reward"] as! Double, decimal: 4).description + " daily"
                }
                
                if let amount = (dictionary["stake_balance"] as? NSString)?.doubleValue {
                    self.lbStakingAmount.text = NumberFormat.init(value: amount, decimal: 4).description
                    self.stakingAmount = amount
                } else {
                    self.lbStakingAmount.text = NumberFormat.init(value: dictionary["stake_balance"] as! Double, decimal: 4).description
                    self.stakingAmount = dictionary["stake_balance"] as! Double
                }
                self.showToast(message: dictionary["message"] as! String)
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
    
    func submitUnStaking(param: NSDictionary) {
        self.startAnimating()
        RequestHandler.stakeRelease(parameter: param as NSDictionary, success: { (successResponse) in
                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            let success = dictionary["success"] as? Bool
            if success == true {
                var coin : StakeModel!
                
//                if let coinData = dictionary["stake_histories"] as? [[String:Any]] {
//                    self.historyList = [StakeModel]()
//                    for item in coinData {
//                        coin = StakeModel(fromDictionary: item)
//                        self.historyList.append(coin)
//                    }
//                    self.historyTable.reloadData()
//                }
                
                if let coinBalanceTemp = (dictionary["coin_balance"] as? NSString)?.doubleValue {
                    self.coinBalance = (NumberFormat.init(value: coinBalanceTemp, decimal: 4).description as! NSString).doubleValue
                } else {
                    self.coinBalance = (NumberFormat.init(value: dictionary["coin_balance"] as! Double, decimal: 4).description as! NSString).doubleValue
                }
                
                self.lbBalance.text = NumberFormat.init(value: self.coinBalance, decimal: 4).description
                
//                self.lbYearlyRewardPercent.text = "+\(dictionary["yearly_fee"]!)%"
                
                if let daily = (dictionary["daily_reward"] as? NSString)?.doubleValue {
                    self.lbDailyReward.text = "+" + NumberFormat.init(value: daily, decimal: 4).description + " daily"
                } else {
                    self.lbDailyReward.text = "+" + NumberFormat.init(value: dictionary["daily_reward"] as! Double, decimal: 4).description + " daily"
                }
                
                if let amount = (dictionary["stake_balance"] as? NSString)?.doubleValue {
                    self.lbStakingAmount.text = NumberFormat.init(value: amount, decimal: 4).description
                    self.stakingAmount = amount
                } else {
                    self.lbStakingAmount.text = NumberFormat.init(value: dictionary["stake_balance"] as! Double, decimal: 4).description
                    self.stakingAmount = dictionary["stake_balance"] as! Double
                }
                
                self.showToast(message: dictionary["message"] as! String)
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
   
    @IBAction func actionUnstake(_ sender: Any) {
        guard let amount = txtAmount.text else {
            return
        }
        
        if amount == "" {
            txtAmount.shake(6, withDelta: 10, speed: 0.06)
            return
        }
        
        if Double(amount)! > stakingAmount {
            self.showToast(message: "Insufficient balance")
            return
        }
        
        let param = ["amount": amount,
                     "id": coinId
        ] as! NSDictionary
        
        let alert = Alert.showConfirmAlert(message: "Are you sure release \(amount) \(self.symbol) ?", handler: {
            (_) in
            if self.coin.type == "Stellar" || self.coin.type == "Token"
            {
                self.sendStellar(param: param, type: "unstake")
            } else {
                self.submitUnStaking(param: param)
            }
        })
        self.presentVC(alert)
    }
    
    @IBAction func actionStake(_ sender: Any) {
        guard let amount = txtAmount.text else {
            return
        }
        
        if amount == "" {
            txtAmount.shake(6, withDelta: 10, speed: 0.06)
            return
        }
        
        if Double(amount)! > coinBalance {
            self.showToast(message: "Insufficient balance")
            return
        }
        
        let param = ["amount": amount,
                     "id": coinId
        ] as! NSDictionary
        
        let alert = Alert.showConfirmAlert(message: "Are you sure staking \(amount) \(self.symbol) ?", handler: {
            (_) in
            if self.coin.type == "Stellar" || self.coin.type == "Token"
            {
                self.sendStellar(param: param, type: "stake")
            } else {
                self.submitStaking(param: param)
            }
        })
        self.presentVC(alert)
    }
}
