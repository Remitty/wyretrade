//
//  CoinsController.swift
//  wyretrade
//
//  Created by maxus on 3/1/21.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
                }
                self.coinTable.reloadData()
            }
            
            self.lbHolding.text = PriceFormat.init(amount: (dictionary["total_balance"] as! NSString).doubleValue, currency: Currency.usd).description
            
            var effect: Double = (dictionary["total_effect"] as! NSString).doubleValue
            self.lbChangePercent.text = CoinFormat.init(value: effect, decimal: 4).description + " %"
            
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
    
    
}
 
extension CoinsController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coinList.count
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
        
    }
    
    func depositParamData(param: NSDictionary) {
        print(param)
        RequestHandler.coinDeposit(parameter: param, success: {(successResponse) in
            let dictionary = successResponse as! [String: Any]
            
            var address = dictionary["address"] as! String
            print(address)
        
        }) {
            (error) in
            let alert = Alert.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
}
