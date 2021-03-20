//
//  TradeTokenController.swift
//  wyretrade
//
//  Created by maxus on 3/8/21.
//

import Foundation
import UIKit

class TradeTokenController: UIViewController {
    
    @IBOutlet weak var tradingView: UIView!
    @IBOutlet weak var chartView: UIView!
    
    @IBOutlet weak var lbXMTBalance: UILabel!
    @IBOutlet weak var lbBtcBalance: UILabel!
    
    @IBOutlet weak var lbHighRate: UILabel!
    @IBOutlet weak var lbLowRate: UILabel!
    
    @IBOutlet weak var lbVolAmount: UILabel!
    @IBOutlet weak var lbAskAmount: UILabel!
    @IBOutlet weak var lbBidAmount: UILabel!
    
    @IBOutlet weak var lbThQty: UILabel!
    @IBOutlet weak var lbThAmount: UILabel!
    
    @IBOutlet weak var orderTable: UITableView! {
        didSet {
            orderTable.delegate = self
            orderTable.dataSource = self
            orderTable.showsVerticalScrollIndicator = false
            orderTable.separatorColor = UIColor.darkGray
            orderTable.separatorStyle = .singleLineEtched
            orderTable.register(UINib(nibName: "TokenOrderItem", bundle: nil), forCellReuseIdentifier: "TokenOrderItem")
            
        }
    }
    
    @IBOutlet weak var askTable: UITableView! {
        didSet {
            askTable.delegate = self
            askTable.dataSource = self
            askTable.showsVerticalScrollIndicator = false
            askTable.separatorColor = UIColor.darkGray
            askTable.separatorStyle = .singleLineEtched
            
            askTable.register(UINib(nibName: "TokenAskItem", bundle: nil), forCellReuseIdentifier: "TokenAskItem")
        }
    }
    
    @IBOutlet weak var bidTable: UITableView! {
        didSet {
            bidTable.delegate = self
            bidTable.dataSource = self
            bidTable.showsVerticalScrollIndicator = false
            bidTable.separatorColor = UIColor.darkGray
            bidTable.separatorStyle = .singleLineEtched
            
            bidTable.register(UINib(nibName: "TokenBidItem", bundle: nil), forCellReuseIdentifier: "TokenBidItem")
        }
    }
    
    
    @IBOutlet weak var lbHighQty: UILabel!
    @IBOutlet weak var lbHighAmount: UILabel!
    
    var orderList = [TokenOrderModel]()
    var askList = [Ask]()
    var bidList = [Ask]()
    
    var selectedPair = "XMT-BTC"
    var pairs = [TokenTradePair]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //        self.addLeftBarButtonWithImage(UIImage(named: "ic_menu")!)
        
        self.addTradeView()
        
        self.loadData()
//        self.loadPairs()
    }
    
    func addTradeView() {
        let tradeVC = storyboard!.instantiateViewController(withIdentifier: "TradeTokenPagerVC")
        addChild(tradeVC)
        tradingView.addSubview(tradeVC.view)
        tradeVC.view.frame = CGRect(x: 0, y: 0, width: 150, height: 310)
        tradeVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        tradeVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        tradeVC.didMove(toParent: self)
    }
    
    func loadData() {
        let param : [String : Any] = ["pair": self.selectedPair]
                RequestHandler.xmtTradeData(parameter: param as NSDictionary, success: { (successResponse) in
        //                        self.stopAnimating()
                    let dictionary = successResponse as! [String: Any]
                   let data = TokenTradeDataModel(fromDictionary: dictionary)
                    self.orderList = data.orders
                    self.askList = data.asks
                    self.bidList = data.bids
                    
                    self.orderTable.reloadData()
                    self.askTable.reloadData()
                    self.bidTable.reloadData()
                    self.lbThQty.text = "Qty(\(data.coin2!))"
                    self.lbLowRate.text = data.lastLow + data.coin2
                    self.lbHighRate.text = data.lastHigh + data.coin2
                    self.lbHighQty.text = data.maxBid.qty
                    self.lbHighAmount.text = data.maxBid.price
                    self.lbVolAmount.text = data.changeVol
                    self.lbAskAmount.text = data.asksTotal
                    self.lbBidAmount.text = data.bidsTotal
                    self.lbXMTBalance.text = "\(data.coin2Balance!) \(data.coin2!)"
                    self.lbBtcBalance.text = "\(data.coin1Balance!) \(data.coin1!)"
                    NotificationCenter.default.post(name: .didUpdateBalance, object: data)
                    }) { (error) in
                        let alert = Alert.showBasicAlert(message: error.message)
                                self.presentVC(alert)
                    }
    }
    
    func loadPairs() {
        let param : [String : Any] = [:]
                RequestHandler.xmtTradeList(parameter: param as NSDictionary, success: { (successResponse) in
        //                        self.stopAnimating()
                    let dictionary = successResponse as! [[String: Any]]
                   
                    var pair : TokenTradePair!
                                
                    
                        self.pairs = [TokenTradePair]()
                        for item in dictionary {
                            pair = TokenTradePair(fromDictionary: item)
                            self.pairs.append(pair)
                        }
                        
                    
                    
                    }) { (error) in
                        let alert = Alert.showBasicAlert(message: error.message)
                                self.presentVC(alert)
                    }
    }
    
    @IBAction func actionViewHistory(_ sender: Any) {
        let detailController = storyboard?.instantiateViewController(withIdentifier: "TradeTokenHistoryController") as! TradeTokenHistoryController
        detailController.pair = self.selectedPair
        self.navigationController?.pushViewController(detailController, animated: true)
    }
    
}

extension TradeTokenController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case orderTable:
            
            return orderList.count
        case askTable:
            
            return askList.count
        case bidTable:
            
            return bidList.count
        default:
            print("default")
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView {
        case orderTable:
            let cell: TokenOrderItem = tableView.dequeueReusableCell(withIdentifier: "TokenOrderItem", for: indexPath) as! TokenOrderItem
            let item = orderList[indexPath.row]
            cell.lbPair.text = item.pair
            cell.lbQty.text = item.qty
            cell.lbPrice.text = item.price
            cell.lbType.text = item.type
            return cell
        case askTable:
            let cell: TokenAskItem = tableView.dequeueReusableCell(withIdentifier: "TokenAskItem", for: indexPath) as! TokenAskItem
            let item = askList[indexPath.row]
            
            cell.lbQty.text = item.qty
            cell.lbPrice.text = item.price
            return cell
        case bidTable:
            let cell: TokenBidItem = tableView.dequeueReusableCell(withIdentifier: "TokenBidItem", for: indexPath) as! TokenBidItem
            let item = bidList[indexPath.row]
            
            cell.lbQty.text = item.qty
            cell.lbPrice.text = item.price
            return cell
        default:
            print("No cell")
            let cell = UITableViewCell()
            return cell
        }
        

        
    }
}
extension Notification.Name {
    static let didUpdateBalance = Notification.Name("didUpdateBalance")
    
}
