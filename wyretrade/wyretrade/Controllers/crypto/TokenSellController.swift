//
//  TokenSellController.swift
//  wyretrade
//
//  Created by brian on 3/18/21.
//

import Foundation
import XLPagerTabStrip
import NVActivityIndicatorView

class TokenSellController: UIViewController, IndicatorInfoProvider, UITextFieldDelegate, NVActivityIndicatorViewable {
    var itemInfo: IndicatorInfo = "Sell"
    
    @IBOutlet weak var lbBtcBalance: UILabel!
    
    @IBOutlet weak var txtQty: UITextField! {
        didSet {
            txtQty.delegate = self
        }
    }
    
    @IBOutlet weak var txtPrice: UITextField! {
        didSet {
            txtPrice.delegate = self
        }
    }
    
    
    @IBOutlet weak var lbTotal: UILabel!
    @IBOutlet weak var lbBtcPrice: UILabel!
    
    var pair = ""
    var qty = 0.0
    var price = 0.0
    var btcPrice = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        txtQty.addTarget(self, action: #selector(TokenBuyController.amountTextFiledDidChange), for: .editingChanged)
        txtPrice.addTarget(self, action: #selector(TokenBuyController.priceTextFiledDidChange), for: .editingChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDidUpdateBalance(notification:)), name: .didUpdateBalance, object: nil)
    }

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    @objc func handleDidUpdateBalance(notification: Notification) {
        
        if let data = notification.object as? TokenTradeDataModel {
            self.lbBtcBalance.text = "\(data.coin1Balance!) \(data.coin1!)"
            self.pair = data.coin2 + "-" + data.coin1
            btcPrice = data.btcPrice
            guard let price = self.txtPrice.text else {
                return
            }
            if price == "" {
                return
            }
            
            self.lbBtcPrice.text = PriceFormat(amount: Double(price)! * data.btcPrice, currency: Currency.usd).description
        }
    }
    
    @objc func amountTextFiledDidChange(_ textField: UITextField) {
        guard let amount = textField.text else {
            return
        }
        
        if  amount == "" {
            return
        }
        
        qty = Double(amount)!
        
        self.lbTotal.text = NumberFormat(value: qty*price, decimal: 6).description + " BTC"
    }
    
    @objc func priceTextFiledDidChange(_ textField: UITextField) {
        guard let amount = textField.text else {
            return
        }
        
        if  amount == "" {
            return
        }
        
        price = Double(amount)!
        
        self.lbTotal.text = NumberFormat(value: qty*price, decimal: 6).description + " BTC"
        lbBtcPrice.text = PriceFormat(amount: btcPrice*price, currency: Currency.usd).description
    }
    
    func submitSell(param: NSDictionary!) {
        self.startAnimating()
        RequestHandler.coinTrade(parameter: param as NSDictionary, success: { (successResponse) in
                                self.stopAnimating()
                    let dictionary = successResponse as! [String: Any]
            self.showToast(message: "Request successfully")
                    }) { (error) in
                        self.stopAnimating()
                        let alert = Alert.showBasicAlert(message: error.message)
                                self.presentVC(alert)
                    }
    }
    
    @IBAction func actionSell(_ sender: Any) {
        guard let qty = txtQty.text else{
            return
        }
        
        guard let price = txtPrice.text else{
            return
        }
        
        if qty == "" {
            txtQty.shake(6, withDelta: 10, speed: 0.06)
            return
        }
        
        if price == "" {
            txtPrice.shake(6, withDelta: 10, speed: 0.06)
            return
        }
        
        let param = [
            "quantity": qty,
            "price": price,
            "pair": pair,
            "type": "sell"
        ] as! NSDictionary
        
        let alert = Alert.showConfirmAlert(message: "Are you sure selling \(qty)?", handler: { (_) in self.submitSell(param: param)})
        self.presentVC(alert)
    }
    
    
}
