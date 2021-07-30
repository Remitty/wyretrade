//
//  StocksDepositCardController.swift
//  wyretrade
//
//  Created by maxus on 3/4/21.
//

import Foundation
import UIKit
import XLPagerTabStrip
import NVActivityIndicatorView

class StocksDepositCardController: UIViewController, IndicatorInfoProvider, UITextFieldDelegate, NVActivityIndicatorViewable {
    
    var itemInfo: IndicatorInfo = "Card"
    
    var stocksBalance = 0.0
    var checkMargin = false
    var card: CardModel!

    @IBOutlet weak var lbStocksBalance: UILabel!
    @IBOutlet weak var lbCardNo: UILabel!
    
    @IBOutlet weak var txtAmount: UITextField! {
        didSet {
            txtAmount.delegate = self
        }
    }
    @IBOutlet weak var btnMarginCheck: UIButton!
    
    @IBOutlet weak var btnChange: UIButton!
    @IBOutlet weak var btnAddCard: UIButton!
    @IBOutlet weak var btnEditCard: UIButton!
    
    @IBOutlet weak var btnTransfer: UIButton! {
        didSet {
            btnTransfer.round()
        }
    }

    @IBOutlet weak var btnHistory: UIButton! {
        didSet {
            btnHistory.round()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        lbStocksBalance.text = PriceFormat.init(amount: stocksBalance, currency: Currency.usd).description
        if card != nil {
            lbCardNo.text = card.lastFour
            btnAddCard.isHidden = true
            btnChange.isHidden = false
            btnEditCard.isHidden = false
        } else {
            btnAddCard.isHidden = false
            btnChange.isHidden = true
            btnEditCard.isHidden = true
        }
        
    }

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    func submitTransfer(param: NSDictionary) {
        self.startAnimating()
        RequestHandler.depositStocks(parameter: param as NSDictionary, success: { (successResponse) in
                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            
            if let stockBalance = (dictionary["stock_balance"] as? NSString)?.doubleValue {
                self.stocksBalance = stockBalance
            } else {
                self.stocksBalance = dictionary["stock_balance"] as! Double
            }
   
            }) { (error) in
                        self.stopAnimating()
                let alert = Alert.showBasicAlert(message: error.message)
                        self.presentVC(alert)
            }
    }
    
    func showMarginFeeAlert() {
        let defaults = UserDefaults.init()
        let alert = Alert.showBasicAlert(message: defaults.string(forKey: "msgMarginAccountUsagePolicy")!)
        self.presentVC(alert)
    }
    
    func checkCVC(param: NSDictionary) {
        let alert = UIAlertController(title: "Confirm CVV", message: "Please confirm your 3 digit CVV at the back of your card", preferredStyle: UIAlertController.Style.alert)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            let textCVV = alert.textFields?.first as! UITextField
            let cvv = textCVV.text! as! String
            if cvv.isEmpty {
                textCVV.shake(6, withDelta: 10, speed: 0.06)
                return
            }
            self.submitTransfer(param: param)
        }
        alert.addTextField { (textField) in
            textField.placeholder = "CVV"
            textField.keyboardType = .numberPad
        }
        alert.addAction(confirmAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.presentVC(alert)
    }
    
    @IBAction func actionCheckMargin(_ sender: Any) {
        if checkMargin {
            checkMargin = false
            btnMarginCheck.setImage(UIImage(systemName: "squareshape"), for: .normal)
        } else {
            checkMargin = true
            btnMarginCheck.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            showMarginFeeAlert()
        }
    }
    
    
    @IBAction func actionHistory(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "StocksDepositCoinHistoryController") as! StocksDepositCoinHistoryController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionChangeCard(_ sender: Any) {
    }
    
    @IBAction func actionEdiCard(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "CardController") as! CardController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionAddCard(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "CardController") as! CardController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func actionTransfer(_ sender: Any) {
        if card == nil {
            let alert = Alert.showBasicAlert(message: "No card")
            self.presentVC(alert)
        }
        guard let amount = txtAmount.text else {
            return
        }
      
        if !amount.isValid(regex: "/^\\d*\\.?\\d*$/") {
            self.txtAmount.shake(6, withDelta: 10, speed: 0.06)
            return
        }
        
        let defaults = UserDefaults.standard
        
        if Double(amount)! > defaults.double(forKey: "stock_deposit_from_card_daily_limit") {
            let alert = Alert.showBasicAlert(message: "Limit is $\(defaults.string(forKey: "stock_deposit_from_card_daily_limit")!)")
            self.presentVC(alert)
            return
        }
        
        
        let param = [
            "amount" : amount,
            "type": 2,
            "cardId": card.cardId,
            "check_margin": checkMargin
        ] as! NSDictionary
        
        
        
        let alert = Alert.showConfirmAlert(message: "Amount: $\(amount)\n Deposit Fee: \(defaults.string(forKey: "stock_deposit_from_card_fee_percent")!)% \n Daily limit: $\(defaults.string(forKey: "stock_deposit_from_card_daily_limit")!) ", handler: {
            (_) in
            self.checkCVC(param: param)
            
        })
        self.presentVC(alert)
    }
}
