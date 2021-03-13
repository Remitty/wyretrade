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
    var buyCoinId = ""
    var sellCoinId = ""
    var sellAmount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.loadHistory()
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
        guard let email = txtEmail.text else {
                    return
                }
        guard let password = txtPassword.text else {
            return
        }
        if email == "" {
            self.txtEmail.shake(6, withDelta: 10, speed: 0.06)
        }
        else if !email.isValidEmail {
            self.txtEmail.shake(6, withDelta: 10, speed: 0.06)
        }
        else if password == "" {
             self.txtPassword.shake(6, withDelta: 10, speed: 0.06)
        }
        else {
            let param : [String : Any] = [
                "email" : email,
                "password": password,
                "device_id" : "ios",
                "device_token" : "ios"
            ]
            
//                    self.showLoader()
            RequestHandler.loginUser(parameter: param as NSDictionary, success: { (successResponse) in
//                        self.stopAnimating()
                let dictionary = successResponse as! [String: Any]
                let success = dictionary["success"] as! Bool
                var user : UserAuthModel!
                if success {
                    if let userData = dictionary["user"] as? [String:Any] {
                        
                        user = UserAuthModel(fromDictionary: userData)
                    }
                    if user.isCompleteProfile == false {
                        let completeVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileEditController") as! ProfileEditController
                        self.navigationController?.pushViewController(completeVC, animated: true)
                    } else {
                        self.defaults.set(true, forKey: "isLogin")
                        self.defaults.synchronize()
                        let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "MainController") as! MainController
                        self.navigationController?.pushViewController(mainVC, animated: true)
                        // self.appDelegate.moveToHome()
                    }
                } else {
                    let alert = Alert.showBasicAlert(message: dictionary["message"] as! String)
                    self.presentVC(alert)
                }
            }) { (error) in
                let alert = Alert.showBasicAlert(message: error.message)
                        self.presentVC(alert)
            }
        }
    }

    @IBAction func actionSelectSellCoin(_ sender: Any) {
    }
    
    @IBAction func actionSubmit(_ sender: Any) {
        self.submitExchange()
    }
    @IBAction func actionSelectBuyCoin(_ sender: Any) {
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
