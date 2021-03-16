//
//  ProfileEditController.swift
//  wyretrade
//
//  Created by maxus on 3/3/21.
//

import Foundation
import UIKit

class ProfileEditController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtFirstName: UITextField! {
        didSet {
            txtFirstName.delegate = self
        }
    }
    @IBOutlet weak var txtLastName: UITextField! {
       didSet {
        txtLastName.delegate = self
       }
   }
    @IBOutlet weak var txtEmail: UITextField! {
       didSet {
        txtEmail.delegate = self
       }
   }
    @IBOutlet weak var txtPhone: UITextField! {
        didSet {
            txtPhone.delegate = self
        }
    }
    @IBOutlet weak var txtDob: UITextField! {
        didSet {
            txtDob.delegate = self
        }
    }
    @IBOutlet weak var txtAddress1: UITextField! {
        didSet {
            txtAddress1.delegate = self
        }
    }
    @IBOutlet weak var txtAddress2: UITextField! {
        didSet {
            txtAddress2.delegate = self
        }
    }
    @IBOutlet weak var txtCity: UITextField! {
        didSet {
            txtCity.delegate = self
        }
    }
    @IBOutlet weak var txtCountry: UITextField! {
        didSet {
            txtCountry.delegate = self
        }
    }
    @IBOutlet weak var txtNationality: UITextField! {
        didSet {
            txtNationality.delegate = self
        }
    }
    @IBOutlet weak var txtPostalCode: UITextField! {
        didSet {
            txtPostalCode.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.loadProfile()
    }
    
    func loadProfile() {
        let param = [:] as! NSDictionary
        RequestHandler.getProfile(parameter: param as NSDictionary, success: { (successResponse) in
//                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            var user : UserModel!
            
            if let userData = dictionary as? [String:Any] {
                
                user = UserModel(fromDictionary: userData)
                self.txtFirstName.text = user.first_name
                self.txtLastName.text = user.last_name
                self.txtEmail.text = user.email
                self.txtCity.text = user.city
                self.txtDob.text = user.dob
                self.txtPhone.text = user.phone
                self.txtCountry.text = user.country
                self.txtNationality.text = user.national
                self.txtAddress1.text = user.address
                self.txtAddress2.text = user.address2
                self.txtPostalCode.text = user.postal_code
            }
                
            
        }) { (error) in
            let alert = Alert.showBasicAlert(message: error.message)
                    self.presentVC(alert)
        }
    }


    @IBAction func actionUpdate(_ sender: Any) {
        if txtFirstName.text == "" {
            txtFirstName.shake(6, withDelta: 10, speed: 0.06)
            return
        }
        if txtLastName.text == "" {
            txtLastName.shake(6, withDelta: 10, speed: 0.06)
            return
        }
        if txtEmail.text == "" {
            txtEmail.shake(6, withDelta: 10, speed: 0.06)
            return
        }
        if txtPhone.text == "" {
            txtPhone.shake(6, withDelta: 10, speed: 0.06)
            return
        }
        if txtDob.text == "" {
            txtDob.shake(6, withDelta: 10, speed: 0.06)
            return
        }
        if txtAddress1.text == "" {
            txtAddress1.shake(6, withDelta: 10, speed: 0.06)
            return
        }
        if txtAddress2.text == "" {
            txtAddress2.shake(6, withDelta: 10, speed: 0.06)
            return
        }
        if txtCity.text == "" {
            txtCity.shake(6, withDelta: 10, speed: 0.06)
            return
        }
        if txtCountry.text == "" {
            txtCountry.shake(6, withDelta: 10, speed: 0.06)
            return
        }
        if txtNationality.text == "" {
            txtNationality.shake(6, withDelta: 10, speed: 0.06)
            return
        }
        if txtPostalCode.text == "" {
            txtPostalCode.shake(6, withDelta: 10, speed: 0.06)
            return
        }
        
        let param = [
            "first_name": txtFirstName.text,
            "last_name": txtLastName.text,
            "email": txtEmail.text,
            "mobile": txtPhone.text,
            "address": txtAddress1.text,
            "address2": txtAddress2.text,
            "country": txtCountry.text,
            "city": txtCity.text,
            "region": txtNationality.text,
            "dob": txtDob.text,
            "postalcode": txtPostalCode.text
        ] as! NSDictionary
        
        RequestHandler.profileUpdate(parameter: param as NSDictionary, success: { (successResponse) in
//                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            let success = dictionary["success"] as! Bool
            var user : UserAuthModel!
            if success {
                
                self.showToast(message: "Updated successfully.")
            } else {
                let alert = Alert.showBasicAlert(message: dictionary["message"] as! String)
                self.presentVC(alert)
            }
        }) { (error) in
            let alert = Alert.showBasicAlert(message: error.message)
                    self.presentVC(alert)
        }
        
    }
}
