//
//  USDCRecipientListController.swift
//  wyretrade
//
//  Created by brian on 4/23/21.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class USDCRecipientListController: UIViewController, PaymentUserParameterDelegate, NVActivityIndicatorViewable {
    
    @IBOutlet weak var userTable: UITableView!{
        didSet {
            userTable.delegate = self
            userTable.dataSource = self
            userTable.showsVerticalScrollIndicator = false
            userTable.separatorColor = UIColor.darkGray
            userTable.separatorStyle = .singleLineEtched
            userTable.register(UINib(nibName: "PaymentUser", bundle: nil), forCellReuseIdentifier: "PaymentUser")
        }
    }
    
    var userList = [PaymentUserModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.loadPaymentUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
   
    
    func loadPaymentUsers() {
        self.startAnimating()
        let param : [String : Any] = [:]
        RequestHandler.coinTransferList(parameter: param as NSDictionary, success: { (successResponse) in
                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            var user : PaymentUserModel!
            
            if let userData = dictionary["users"] as? [[String:Any]] {
                self.userList = [PaymentUserModel]()
                for item in userData {
                    user = PaymentUserModel(fromDictionary: item)
                    self.userList.append(user)
                }
                self.userTable.reloadData()
            }
                    
                
            }) { (error) in
                        self.stopAnimating()
                let alert = Alert.showBasicAlert(message: error.message)
                        self.presentVC(alert)
            }
    }
    
    func paramData(param: NSDictionary) {
        self.startAnimating()
        RequestHandler.coinTransferRemoveContact(parameter: param, success: {(successResponse) in
            self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            var user : PaymentUserModel!
            
            if let userData = dictionary["users"] as? [[String:Any]] {
                self.userList = [PaymentUserModel]()
                for item in userData {
                    user = PaymentUserModel(fromDictionary: item)
                    self.userList.append(user)
                }
                self.userTable.reloadData()
            }
        
        }) {
            (error) in
                        self.stopAnimating()
            let alert = Alert.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
}

extension USDCRecipientListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PaymentUser = tableView.dequeueReusableCell(withIdentifier: "PaymentUser", for: indexPath) as! PaymentUser
        let user = userList[indexPath.row]
        cell.name.text = user.contact_name
        cell.email.text = user.email
        cell.contactId = user.id
        
        
        return cell
    }
}

