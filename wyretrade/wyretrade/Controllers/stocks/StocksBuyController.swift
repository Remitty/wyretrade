//
//  StocksBuyController.swift
//  wyretrade
//
//  Created by maxus on 3/5/21.
//

import Foundation
import UIKit
import PopupDialog
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
    @IBOutlet weak var btnTrade: UIButton!
    
    @IBOutlet weak var viewMarket: UIView!
    @IBOutlet weak var viewLimit: UIView!
    @IBOutlet weak var viewCompany: UIView!
    @IBOutlet weak var lbMarket: UILabel!
    @IBOutlet weak var lbLimit: UILabel!
    
    var stocks: StockPositionModel = StockPositionModel.init(fromDictionary: ["avg_price" : "2.33",
                                                                              "change" : "-0.07",
                                                                              "change_percent" : "-2.88",
                                                                              "current_price" : "2.36",
                                                                              "filled_qty" : 12,
                                                                              "holding" : "28.32",
                                                                              "name" : "Verastem, Inc.",
                                                                              "profit" : "-0.84",
                                                                              "symbol" : "VSTM"])
    var order = StocksOrderModel.init(fromDictionary: ["ticker": "", "side": "", "type": "", "order_id": "", "est_cost": "", "status": "", "created_at": "2021-01-22 18:34:04", "qty": "", "limit_price": ""])
    
    var stocksBalance = 0.0
    var stocksShares = 0.0
    var estShares = 0.0
    var company = CompanyModel.init(fromDictionary: ["description": "", "industry": "", "website": ""])
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
        if amount != "" {
            var price = self.stocks.dbPrice
            if isLimit {
                guard let limit = self.txtLimitPrice.text else {
                    return
                }
                price = (limit as! NSString).doubleValue
            }
            
            self.estShares = ((amount as! NSString).doubleValue / price!)
            self.lbEstCost.text = NumberFormat.init(value: self.estShares, decimal: 4).description
        }
 
    }

    @objc func limitTextFieldDidChange(_ textField: UITextField) {
        guard let amount = self.txtAmount.text else {
            return
        }
        if amount == "" {
            return
        }
        guard let limit = textField.text else {
            return
        }
        if limit != "" {
            var price = (limit as! NSString).doubleValue
            self.estShares = ((amount as! NSString).doubleValue / price)
            self.lbEstCost.text = NumberFormat.init(value: self.estShares, decimal: 4).description
        }
    }
    
    private func configCompany() {
        self.companyView.translatesAutoresizingMaskIntoConstraints = false
//        self.viewCompany.addSubview(self.companyView)
    }
    
    func showTradingOptionModal() {
        let cointradecontroller: StocksTradeSelectModal = self.storyboard?.instantiateViewController(withIdentifier: "StocksTradeSelectModal") as! StocksTradeSelectModal
        let popup = PopupDialog(viewController: cointradecontroller,
                                buttonAlignment: .horizontal,
                                transitionStyle: .bounceDown,
                                tapGestureDismissal: true,
                                panGestureDismissal: true)
        let buttonTwo = DefaultButton(title: "Select", height: 30) {
                    print("here")
                }
        popup.addButton(buttonTwo)
        
//        let overlayAppearance = PopupDialogOverlayView.appearance()
//        overlayAppearance.opacity = 0.3
        
        self.presentVC(popup)
    }
    @objc
    func marketClick(sender: UITapGestureRecognizer) {
        
        self.showTradingOptionModal()
        self.viewLimit.isHidden = true
        self.viewMarket.isHidden = false
        self.isLimit = false
    }
    @objc
    func limitClick(sender: UITapGestureRecognizer) {
        self.showTradingOptionModal()
        self.viewLimit.isHidden = false
        self.viewMarket.isHidden = true
        self.isLimit = true
    }
    
    func createOrder(param: NSDictionary) {
        self.startAnimating()
        RequestHandler.createStocksOrder(parameter: param , success: { (successResponse) in
                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            self.stocksBalance = (dictionary["stock_balance"] as! NSString).doubleValue
            self.lbStocksBalance.text = "\(self.stocksBalance)"
            self.stocksShares = (dictionary["shares"] as! NSString).doubleValue
            self.lbStocksShares.text = "\(self.stocksShares)"
            
            self.showToast(message: dictionary["message"] as! String)
            
            
            
        }) { (error) in
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
            let alert = Alert.showBasicAlert(message: error.message)
                    self.presentVC(alert)
        }
    }

    @IBAction func actionSubmit(_ sender: Any) {
        guard let amount = txtAmount.text else {
            return
        }
        
        if amount == "" {
             self.txtAmount.shake(6, withDelta: 10, speed: 0.06)
            return
        }
        
        
        switch self.side {
        case "buy":
            if (amount as! NSString).doubleValue > self.stocksBalance {
                self.showToast(message: "Insufficient balance")
                return
            }
        case "sell":
            if self.estShares > self.stocksShares {
                self.showToast(message: "Insufficient shares")
                return
            }
        case "replace":
            switch self.order.side {
            case "buy":
                if (amount as! NSString).doubleValue > self.stocksBalance {
                    self.showToast(message: "Insufficient balance")
                    return
                }
            case "sell":
                if self.estShares > self.stocksShares {
                    self.showToast(message: "Insufficient shares")
                    return
                }
            default:
                print("no data")
            }
        default:
            print("no data")
        }
        
        var limitPrice = "0"
        if self.isLimit {
            guard let limit = txtLimitPrice.text else {
                return
            }
            
            if limit == "" {
                 self.txtLimitPrice.shake(6, withDelta: 10, speed: 0.06)
                return
            }
            
            limitPrice = limit
        }
        
        
        
        let param : [String : Any] = [
            
            "ticker": self.stocks.ticker!,
            "shares": self.estShares,
            "buyorsell": self.side == "replace" ? self.order.side: self.side,
            "cost": amount,
            "type": self.isLimit ? "limit": "market",
            "limit_price": self.isLimit ? limitPrice: 0
        ]
        
        if self.side != "replace" {
            let alert = Alert.showConfirmAlert(message: "Please confirm your transaction. Trading fees is 0.10 XMT or $0.99. I fyou hold over 100XMT, no trading fee.", handler: {(_) in self.createOrder(param: param as! NSDictionary)})
            self.presentVC(alert)
        } else {
            let alert = Alert.showConfirmAlert(message: "Please confirm your transaction. Trading fees is 0.10 XMT or $0.99. I fyou hold over 100XMT, no trading fee.", handler: {(_) in self.replaceOrder(param: param as! NSDictionary)})
            self.presentVC(alert)
        }
        
        
        
    }
    
}
