//
//  CoinWithdrawController.swift
//  wyretrade
//
//  Created by maxus on 3/5/21.
//

import Foundation
import UIKit

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
    var coin: CoinModel!
    var withdrawFee = 0.0
    var symbol = ""
    var coinId = ""
    var balance = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.addLeftBarButtonWithImage(UIImage(named: "ic_menu")!)
        // Do any additional setup after loading the view.
        txtAmount.addTarget(self, action: #selector(CoinWithdrawController.amountTextFiledDidChange), for: .editingChanged)
        
        self.loadData()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//       super.viewWillAppear(animated)
//       self.navigationController?.isNavigationBarHidden = true
//
//   }
//
//   override func viewWillDisappear(_ animated: Bool) {
//       super.viewWillDisappear(animated)
//       self.navigationController?.isNavigationBarHidden = false
//   }
    
    @objc func amountTextFiledDidChange(_ textField: UITextField) {
        guard let amount = textField.text else {
            return
        }
        
        if  amount == "" {
            return
        }
        
        var est: Double = Double(amount)! - self.withdrawFee
        
        self.lbEstGet.text = "\(est) \(self.symbol)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let next = segue.destination as! CoinSelectController
        next.delegate = self
    }
    
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
                
                var result = CoinModel(fromDictionary: dictionary["result"] as! [String : Any])!
                self.balance = Double(result.balance)!
                self.lbBalance.text = result.balance
                
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
            (_) in self.submitWithdraw(param: param)
        })
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
        self.coin = param
        self.lbBalance.text = param.balance
        self.balance = Double(param.balance)!
        self.lbFee.text = "\(param.withdrawFee!) \(param.symbol!)"
        self.symbol = param.symbol
        self.withdrawFee = param.withdrawFee
        self.coinId = param.id
    }
}
