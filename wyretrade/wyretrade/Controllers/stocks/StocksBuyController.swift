//
//  StocksBuyController.swift
//  wyretrade
//
//  Created by maxus on 3/5/21.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class StocksBuyController: UIViewController, UITextFieldDelegate, NVActivityIndicatorViewable {
    
    @IBOutlet weak var lbStocksSymbol: UILabel!
    @IBOutlet weak var lbStocksName: UILabel!
    @IBOutlet weak var lbStocksBalance: UILabel!
    @IBOutlet weak var lbStocksShares: UILabel!
    @IBOutlet weak var txtAmount: UITextField! {
        didSet {
            txtAmount.delegate = self
        }
    }
    @IBOutlet weak var lbMarketPrice: UILabel!
    @IBOutlet weak var txtLimitPrice: UITextField! {
        didSet {
            txtLimitPrice.delegate = self
        }
    }
    @IBOutlet weak var lbEstCost: UILabel!
    @IBOutlet weak var btnTrade: UIButton! {
        didSet {
            btnTrade.round()
        }
    }
    
    @IBOutlet weak var viewMarket: UIView!
    @IBOutlet weak var viewLimit: UIView!
    @IBOutlet weak var viewCompany: UIView!
    @IBOutlet weak var lbMarket: UILabel!
    @IBOutlet weak var lbLimit: UILabel!


    var stocks: StockPositionModel!
    var order: StocksOrderModel!
    
    var stocksBalance = 0.0
    var stocksShares = 0.0
    var estCost = 0.0
    var price = 0.0
    var orderShares = 0.0

    var company: CompanyModel!
    var side = "buy"
    var isLimit = false
    
    let companyView = Company().loadView() as! Company

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.lbStocksSymbol.text = self.stocks.ticker
        self.lbStocksName.text = self.stocks.name
        self.lbStocksBalance.text = PriceFormat.init(amount: self.stocksBalance, currency: Currency.usd).description
        self.lbStocksShares.text = "\(self.stocks.shares!)"
        self.stocksShares = self.stocks.shares
        self.lbMarketPrice.text = self.stocks.price
        self.price = self.stocks.dbPrice
        
        
        
        switch self.side {
        case "buy":
            self.configCompany()
        case "sell":
            self.btnTrade.setTitle("Sell", for: .normal)
            self.btnTrade.backgroundColor = UIColor.red
        case "replace":
            self.txtAmount.text = "\(self.order.amount!)"
            self.lbEstCost.text = "\(self.order.shares!)"
            self.btnTrade.setTitle("Update \(self.order.side!)", for: .normal)
            if self.order.type == "market" {
                self.viewLimit.isHidden = true
                self.viewMarket.isHidden = false
            } else {
                self.viewLimit.isHidden = false
                self.viewMarket.isHidden = true
                self.txtLimitPrice.text = "\(self.order.limitPrice!)"
                
            }
        default:
            print("no data")
        }
        
        lbMarket.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(StocksBuyController.marketClick))
        lbMarket.addGestureRecognizer(tap)
        lbLimit.isUserInteractionEnabled = true
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(StocksBuyController.limitClick))
        lbLimit.addGestureRecognizer(tap1)
        
        txtAmount.addTarget(self, action: #selector(StocksBuyController.amountTextFieldDidChange), for: .editingChanged)
        txtLimitPrice.addTarget(self, action: #selector(StocksBuyController.limitTextFieldDidChange), for: .editingChanged)
    }
    
    @objc func amountTextFieldDidChange(_ textField: UITextField) {
        guard let amount = textField.text else {
            return
        }
        if amount.isEmpty || amount == "."{
            self.orderShares = 0.0
        } else {
            self.orderShares = Double(amount)!
        }
        
        self.estCost = self.orderShares * price
        self.lbEstCost.text = NumberFormat.init(value: self.estCost, decimal: 2).description
 
    }

    @objc func limitTextFieldDidChange(_ textField: UITextField) {
        
        guard let limit = textField.text else {
            return
        }
        if limit.isEmpty || limit == "." {
            self.price = 0.0
        } else {
            self.price = Double(limit)!
        }
        
        self.estCost = self.orderShares * price
        self.lbEstCost.text = NumberFormat.init(value: self.estCost, decimal: 2).description
    }
    
    private func configCompany() {
        self.companyView.translatesAutoresizingMaskIntoConstraints = false
//        self.viewCompany.addSubview(self.companyView)
    }
    
    func showTradingOptionModal() {
        let alert =  UIAlertController.init(title: "Select option", message: "", preferredStyle: .actionSheet)
        let action1 = UIAlertAction.init(title: "MKT Price", style: .default, handler: { _ in
            self.doMarket()
        })
        let action2 = UIAlertAction.init(title: "Limit Price", style: .default, handler: { _ in
            self.doLimit()
        })
//        let action3 = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(action1)
        alert.addAction(action2)
//        alert.addAction(action3)
        self.presentVC(alert)
    }
    @objc
    func marketClick(sender: UITapGestureRecognizer) {
        
        self.showTradingOptionModal()
        
    }
    @objc
    func limitClick(sender: UITapGestureRecognizer) {
        self.showTradingOptionModal()
        
    }
    
    func doMarket() {
        self.viewLimit.isHidden = true
        self.viewMarket.isHidden = false
        self.isLimit = false
        self.price = self.stocks.dbPrice
        self.estCost = self.orderShares * price
        self.lbEstCost.text = NumberFormat.init(value: self.estCost, decimal: 2).description
    }
    
    func doLimit() {
        self.viewLimit.isHidden = false
        self.viewMarket.isHidden = true
        self.isLimit = true
        guard let limit = self.txtLimitPrice.text else {
            return
        }
        if limit.isEmpty || limit == "." {
            self.price = 0.0
        } else {
            self.price = Double(limit)!
        }
        
        self.estCost = self.orderShares * price
        self.lbEstCost.text = NumberFormat.init(value: self.estCost, decimal: 2).description
    }
    
    func createOrder(param: NSDictionary) {
        self.startAnimating()
        RequestHandler.createStocksOrder(parameter: param , success: { (successResponse) in
                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            
            if let balance = (dictionary["stock_balance"] as? NSString)?.doubleValue {
                self.stocksBalance = (NumberFormat.init(value: balance, decimal: 4).description as! NSString).doubleValue
            } else {
                self.stocksBalance = (NumberFormat.init(value: dictionary["stock_balance"] as! Double, decimal: 4).description as! NSString).doubleValue
            }
            self.lbStocksBalance.text = "\(self.stocksBalance)"
            
            if let shares = (dictionary["shares"] as? NSString)?.doubleValue {
                self.stocksShares = (NumberFormat.init(value: shares, decimal: 4).description as! NSString).doubleValue
            } else {
                self.stocksShares = (NumberFormat.init(value: dictionary["shares"] as! Double, decimal: 4).description as! NSString).doubleValue
            }
            self.lbStocksShares.text = "\(self.stocksShares)"
            
            self.showToast(message: dictionary["message"] as! String)
            
            
            
        }) { (error) in
                        self.stopAnimating()
            let alert = Alert.showBasicAlert(message: error.message)
                    self.presentVC(alert)
        }
    }
    
    func replaceOrder(param: NSDictionary) {
        self.startAnimating()
        RequestHandler.replaceStocksOrder(parameter: param , success: { (successResponse) in
                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            self.stocksBalance = (dictionary["stock_balance"] as! NSString).doubleValue
            self.lbStocksBalance.text = "\(self.stocksBalance)"
            self.stocksShares = (dictionary["shares"] as! NSString).doubleValue
            self.lbStocksShares.text = "\(self.stocksShares)"
            
            self.showToast(message: dictionary["message"] as! String)
            
            
            
        }) { (error) in
                        self.stopAnimating()
            let alert = Alert.showBasicAlert(message: error.message)
                    self.presentVC(alert)
        }
    }

    @IBAction func actionSubmit(_ sender: Any) {
       
        if self.orderShares == 0 {
             self.txtAmount.shake(6, withDelta: 10, speed: 0.06)
            return
        }
        
        if self.isLimit && self.price == 0{
            self.txtLimitPrice.shake(6, withDelta: 10, speed: 0.06)
            return
        }
        
        
        switch self.side {
        case "buy":
            if self.estCost > self.stocksBalance {
                self.showToast(message: "Insufficient balance")
                return
            }
        case "sell":
            if self.orderShares > self.stocksShares {
                self.showToast(message: "Insufficient shares")
                return
            }
        case "replace":
            switch self.order.side {
            case "buy":
                if self.estCost > self.stocksBalance {
                    self.showToast(message: "Insufficient balance")
                    return
                }
            case "sell":
                if self.orderShares > self.stocksShares {
                    self.showToast(message: "Insufficient shares")
                    return
                }
            default:
                print("no data")
            }
        default:
            print("no data")
        }
        
        let defaults = UserDefaults.standard
        
        let param : [String : Any] = [
            
            "ticker": self.stocks.ticker!,
            "shares": orderShares,
            "buyorsell": self.side == "replace" ? self.order.side: self.side,
            "cost": self.estCost,
            "type": self.isLimit ? "limit": "market",
            "limit_price": self.isLimit ? self.price: 0
        ]
        
        if self.side != "replace" {
            let alert = Alert.showConfirmAlert(message: "Please confirm your transaction. \(defaults.string(forKey: "msgStockTradeFeePolicy")!)", handler: {(_) in self.createOrder(param: param as! NSDictionary)})
            self.presentVC(alert)
        } else {
            let alert = Alert.showConfirmAlert(message: "Please confirm your transaction. \(defaults.string(forKey: "msgStockTradeFeePolicy")!)", handler: {(_) in self.replaceOrder(param: param as! NSDictionary)})
            self.presentVC(alert)
        }
        
        
        
    }
    
}
