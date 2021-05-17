//
//  CardController.swift
//  wyretrade
//
//  Created by brian on 5/13/21.
//

import Foundation
import UIKit
import Stripe
import NVActivityIndicatorView

class CardController: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet weak var cardView: UIView!
   
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var cardTable: UITableView! {
        didSet{
            cardTable.dataSource = self
            cardTable.showsVerticalScrollIndicator = false
            cardTable.register(UINib(nibName: "CardItem", bundle: nil), forCellReuseIdentifier: "CardItem")
            cardTable.delegate = self
        }
    }
    @IBOutlet weak var constTableHeight: NSLayoutConstraint!
    
    var cardList = [CardModel]()
    var withdrawal = 0
    var cvv, cardNo: String!
    var month, year: Int!
    let stripeWidget = STPPaymentCardTextField()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getCard()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardView.addSubview(stripeWidget)
        let padding: CGFloat = 0
        stripeWidget.frame = CGRect(
            x: padding,
            y: padding,
            width: cardView.bounds.width - (padding * 2),
            height: 50)
        stripeWidget.postalCodeEntryEnabled = false
    }
    
    func getCard() {
        let param : [String : Any] = ["withdrawal": self.withdrawal]
        self.startAnimating()
        RequestHandler.handleCard(method: .get, parameter: param as NSDictionary, success: { (successResponse) in
            self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            var card : CardModel!
            
            if let data = dictionary["cards"] as? [[String:Any]] {
                self.cardList = [CardModel]()
                for item in data {
                    card = CardModel(fromDictionary: item)
                    self.cardList.append(card)
                }
                self.cardTable.reloadData()
            }
                    
           
            
            }) { (error) in
                self.stopAnimating()
                let alert = Alert.showBasicAlert(message: error.message)
                        self.presentVC(alert)
            }
    }
    
    func addCard() {
        let param : [String : Any] = [
            "withdrawal": self.withdrawal,
            "no": self.cardNo!,
            "month": self.month!,
            "year": self.year!,
            "cvc": self.cvv!
        ]
        self.startAnimating()
        RequestHandler.handleCard(method: .post, parameter: param as NSDictionary, success: { (successResponse) in
             self.stopAnimating()
            
            self.getCard()

            self.showToast(message: "Added successfully")
            
            }) { (error) in
                self.stopAnimating()
                let alert = Alert.showBasicAlert(message: error.message)
                self.presentVC(alert)
            }
    }
    
    func removeCard(id: String, index: Int) {
        let param : [String : Any] = [
            "withdrawal": self.withdrawal,
            "id": id
        ]
        self.startAnimating()
        RequestHandler.handleCard(method: .delete, parameter: param as NSDictionary, success: { (successResponse) in
                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            self.cardList.remove(at: index)

            self.cardTable.reloadData()
            
            self.showToast(message: "Deleted successfully")
            
            }) { (error) in
                self.stopAnimating()
                let alert = Alert.showBasicAlert(message: error.message)
                        self.presentVC(alert)
            }
    }
    
    @IBAction func actionAddCard(_ sender: UIButton) {
        cardNo = stripeWidget.cardNumber
        cvv = stripeWidget.cvc
        month = stripeWidget.expirationMonth
        year = stripeWidget.expirationYear
        
//        if cardNo == nil {
//            self.showToast(message: "Please input card number")
//            return
//        }
//        if cvv == nil {
//            self.showToast(message: "Please input cvv")
//            return
//        }
//        if month  == nil {
//            self.showToast(message: "Please input expiration month")
//            return
//        }
//        if year  == nil {
//            self.showToast(message: "Please input expiration year")
//            return
//        }
//
        if !stripeWidget.isValid {
            let alert = Alert.showBasicAlert(message: "Invalid card format")
            presentVC(alert)
            return
        }
        self.addCard()
    }
    
    
}

extension CardController: CardItemParaDelegate {
    func deleteCard(id: String, index: Int) {
        let alert = Alert.showConfirmAlert(message: "Are you sure you want to remove this card?", handler: {
            (_) in self.removeCard(id: id, index: index)
        })
        self.presentVC(alert)
    }
}

extension CardController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CardItem = tableView.dequeueReusableCell(withIdentifier: "CardItem", for: indexPath) as! CardItem
        let item = cardList[indexPath.row]
        cell.delegate = self
        cell.id = item.cardId
        cell.index = indexPath.row
        cell.lbCardNo.text = item.lastFour
        if item.brand == "Visa" {
//            cell.imgIcon.set
        }
        
        
        return cell
    }
    
}
