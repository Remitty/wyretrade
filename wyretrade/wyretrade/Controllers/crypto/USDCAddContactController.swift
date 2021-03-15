//
//  USDCAddContactController.swift
//  wyretrade
//
//  Created by maxus on 3/6/21.
//

import Foundation
import UIKit

class USDCAddContactController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, PaymentUserParameterDelegate {

    @IBOutlet weak var txtName: UITextField! {
        didSet {
            txtName.delegate = self
        }
    }
    @IBOutlet weak var txtEmail: UITextField! {
        didSet {
            txtEmail.delegate = self
        }
    }
    @IBOutlet weak var btnAdd: UIButton!
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
    
    func loadPaymentUsers() {
        let param : [String : Any] = [:]
        RequestHandler.coinTransferList(parameter: param as NSDictionary, success: { (successResponse) in
//                        self.stopAnimating()
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
                let alert = Alert.showBasicAlert(message: error.message)
                        self.presentVC(alert)
            }
    }
    
    func paramData(param: NSDictionary) {
        RequestHandler.coinTransferRemoveContact(parameter: param, success: {(successResponse) in
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
            let alert = Alert.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
    func addContact(param: NSDictionary) {
        RequestHandler.coinTransferAddContact(parameter: param, success: {(successResponse) in
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
            let alert = Alert.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }

    @IBAction func actionSubmit(_ sender: Any) {
        guard let email = txtEmail.text else {
                    return
                }
        guard let name = txtName.text else {
            return
        }
        if email == "" {
            self.txtEmail.shake(6, withDelta: 10, speed: 0.06)
        }
        else if !email.isValidEmail {
            self.txtEmail.shake(6, withDelta: 10, speed: 0.06)
        }
        else if name == "" {
             self.txtName.shake(6, withDelta: 10, speed: 0.06)
        } else {
            let param: NSDictionary = [
                "email" : email,
                "name": name,
            ]
            
            self.addContact(param: param)
        }
        
        
    }
    
}
