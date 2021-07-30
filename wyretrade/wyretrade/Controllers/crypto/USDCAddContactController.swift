//
//  USDCAddContactController.swift
//  wyretrade
//
//  Created by maxus on 3/6/21.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class USDCAddContactController: UIViewController, UITextFieldDelegate, NVActivityIndicatorViewable {

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
    @IBOutlet weak var btnAdd: UIButton! {
        didSet {
            btnAdd.round()
        }
    }
    
    @IBOutlet weak var btnRec: UIButton! {
        didSet {
            btnRec.round()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        self.loadPaymentUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func addContact(param: NSDictionary) {
        self.startAnimating()
        RequestHandler.coinTransferAddContact(parameter: param, success: {(successResponse) in
            self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
        
        }) {
            (error) in
                        self.stopAnimating()
            let alert = Alert.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
    @IBAction func actionReciients(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "USDCRecipientListController") as! USDCRecipientListController
        self.navigationController?.pushViewController(vc, animated: true)
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
