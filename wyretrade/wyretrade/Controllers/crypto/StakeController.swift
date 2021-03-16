//
//  StakeController.swift
//  wyretrade
//
//  Created by maxus on 3/3/21.
//

import Foundation
import UIKit

class StakeController: UIViewController, UITextFieldDelegate {
    
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
    @IBOutlet weak var lbSymbol2: UILabel!
    @IBOutlet weak var historyTable: UITableView!{
        didSet {
            historyTable.delegate = self
            historyTable.dataSource = self
            historyTable.showsVerticalScrollIndicator = false
            historyTable.separatorColor = UIColor.darkGray
            historyTable.separatorStyle = .singleLineEtched
            historyTable.register(UINib(nibName: "StakeItem", bundle: nil), forCellReuseIdentifier: "StakeItem")
        }
    }
    
    var historyList = [StakeModel]()
    var coinId = "0"
    var symbol = ""
    var coinBalance = 0.0
    var stakingAmount = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.loadData()
        
        lbSymbol.text = self.symbol
        lbSymbol2.text = self.symbol
    }
    
    func loadData() {
        let param : [String : Any] = ["id": self.coinId]
        RequestHandler.getStakeBalance(parameter: param as NSDictionary, success: { (successResponse) in
//                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            var coin : StakeModel!
            
            if let coinData = dictionary["stake_histories"] as? [[String:Any]] {
                self.historyList = [StakeModel]()
                for item in coinData {
                    coin = StakeModel(fromDictionary: item)
                    self.historyList.append(coin)
                }
                self.historyTable.reloadData()
            }
            
            if let coinBalanceTemp = (dictionary["coin_balance"] as? NSString)?.doubleValue {
                self.coinBalance = (NumberFormat.init(value: coinBalanceTemp, decimal: 4).description as! NSString).doubleValue
            } else {
                self.coinBalance = (NumberFormat.init(value: dictionary["coin_balance"] as! Double, decimal: 4).description as! NSString).doubleValue
            }
            
            self.lbBalance.text = NumberFormat.init(value: self.coinBalance, decimal: 4).description
            
            self.lbYearlyRewardPercent.text = "+\(dictionary["yearly_fee"]!)%"
            
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
            
            }) { (error) in
                let alert = Alert.showBasicAlert(message: error.message)
                        self.presentVC(alert)
            }
    }

    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       self.navigationController?.isNavigationBarHidden = true

   }

   override func viewWillDisappear(_ animated: Bool) {
       super.viewWillDisappear(animated)
       self.navigationController?.isNavigationBarHidden = false
   }
    
    func submitStaking(param: NSDictionary) {
        RequestHandler.stake(parameter: param as NSDictionary, success: { (successResponse) in
//                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            let success = dictionary["success"] as? Bool
            if success == true {
                var coin : StakeModel!
                
                if let coinData = dictionary["stake_histories"] as? [[String:Any]] {
                    self.historyList = [StakeModel]()
                    for item in coinData {
                        coin = StakeModel(fromDictionary: item)
                        self.historyList.append(coin)
                    }
                    self.historyTable.reloadData()
                }
                
                if let coinBalanceTemp = (dictionary["coin_balance"] as? NSString)?.doubleValue {
                    self.coinBalance = (NumberFormat.init(value: coinBalanceTemp, decimal: 4).description as! NSString).doubleValue
                } else {
                    self.coinBalance = (NumberFormat.init(value: dictionary["coin_balance"] as! Double, decimal: 4).description as! NSString).doubleValue
                }
                
                self.lbBalance.text = NumberFormat.init(value: self.coinBalance, decimal: 4).description
                
                self.lbYearlyRewardPercent.text = "+\(dictionary["yearly_fee"]!)%"
                
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
                let alert = Alert.showBasicAlert(message: error.message)
                        self.presentVC(alert)
            }
    }
    
    func submitUnStaking(param: NSDictionary) {
        RequestHandler.stakeRelease(parameter: param as NSDictionary, success: { (successResponse) in
//                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            let success = dictionary["success"] as? Bool
            if success == true {
                var coin : StakeModel!
                
                if let coinData = dictionary["stake_histories"] as? [[String:Any]] {
                    self.historyList = [StakeModel]()
                    for item in coinData {
                        coin = StakeModel(fromDictionary: item)
                        self.historyList.append(coin)
                    }
                    self.historyTable.reloadData()
                }
                
                if let coinBalanceTemp = (dictionary["coin_balance"] as? NSString)?.doubleValue {
                    self.coinBalance = (NumberFormat.init(value: coinBalanceTemp, decimal: 4).description as! NSString).doubleValue
                } else {
                    self.coinBalance = (NumberFormat.init(value: dictionary["coin_balance"] as! Double, decimal: 4).description as! NSString).doubleValue
                }
                
                self.lbBalance.text = NumberFormat.init(value: self.coinBalance, decimal: 4).description
                
                self.lbYearlyRewardPercent.text = "+\(dictionary["yearly_fee"]!)%"
                
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
            (_) in self.submitUnStaking(param: param)
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
            (_) in self.submitStaking(param: param)
        })
        self.presentVC(alert)
    }
}

extension StakeController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: StakeItem = tableView.dequeueReusableCell(withIdentifier: "StakeItem", for: indexPath) as! StakeItem
        let item = historyList[indexPath.row]
        cell.lbActivity.text = item.type
        cell.lbToken.text = item.token
        cell.lbQty.text = item.qty
        cell.lbDate.text = item.date
        
        
        return cell
    }
}
