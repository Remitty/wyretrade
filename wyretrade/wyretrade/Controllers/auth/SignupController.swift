//
//  SignupController.swift
//  wyretrade
//
//  Created by maxus on 3/5/21.
//

import Foundation
import UIKit
import MaterialComponents
import NVActivityIndicatorView

class SignupController: UIViewController, UITextFieldDelegate, NVActivityIndicatorViewable {

    @IBOutlet weak var txtFirstName: UITextField! {
        didSet {
            txtFirstName.delegate = self
        }
    }
    @IBOutlet weak var txtLastName: UITextField!{
        didSet {
            txtLastName.delegate = self
        }
    }
    @IBOutlet weak var txtPassword: UITextField!{
        didSet {
            txtPassword.delegate = self
        }
    }
    @IBOutlet weak var txtEmail: UITextField!{
        didSet {
            txtEmail.delegate = self
        }
    }
    
    @IBOutlet weak var btnSignin: UIButton!
    @IBOutlet weak var btnRegister: UIButton! {
        didSet {
            btnRegister.roundCorners()
            btnRegister.layer.borderWidth = 1
        }
    }
    
    var defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       self.navigationController?.isNavigationBarHidden = true
       
   }

   override func viewWillDisappear(_ animated: Bool) {
       super.viewWillDisappear(animated)
       self.navigationController?.isNavigationBarHidden = false
   }

    @IBAction func gotoSignin(_ sender: Any) {
//        let loginVC = storyboard?.instantiateViewController(withIdentifier: "SigninController") as! SigninController
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionSubmit(_ sender: Any) {
        guard let firstName = txtFirstName.text else {
            return
        }
        guard let lastName = txtLastName.text else {
            return
        }
        guard let email = txtEmail.text else {
            return
        }
        guard let password = txtPassword.text else {
            return
        }
        
        if firstName == "" {
             self.txtFirstName.shake(6, withDelta: 10, speed: 0.06)
        }
        if lastName == "" {
             self.txtLastName.shake(6, withDelta: 10, speed: 0.06)
        }
        else if email == "" {
            self.txtEmail.shake(6, withDelta: 10, speed: 0.06)
        }
        else if !email.isValidEmail {
            self.txtEmail.shake(6, withDelta: 10, speed: 0.06)
        }
        else if password == "" {
            self.txtPassword.shake(6, withDelta: 10, speed: 0.06)
        }

        else {
            let defaults = UserDefaults.standard
            
            let param : [String: Any] = [
                "first_name": firstName,
                "last_name": lastName,
                "email": email,
                "password": password,
                "device_token": "ios",
                "referred_by": defaults.string(forKey: "invitedBy")
            ]
            
            self.startAnimating()
        RequestHandler.registerUser(parameter: param as NSDictionary, success: { (successResponse) in
            self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            let success = dictionary["success"] as! Bool
            var user : UserAuthModel!
            if success {
                
                    self.defaults.set(true, forKey: "isLogin")
                    self.defaults.synchronize()
//                    self.moveToCompleteProfile()
                
                let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "SplashController") as! SplashController
                self.navigationController?.pushViewController(mainVC, animated: true)
                
            }
            else {
                let alert = Alert.showBasicAlert(message: dictionary["message"] as! String)
                self.presentVC(alert)
            }
        }) { (error) in
                        self.stopAnimating()
            let alert = Alert.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
        }
    }
    
    func moveToCompleteProfile() {
        let completeVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileEditController") as! ProfileEditController
        self.navigationController?.pushViewController(completeVC, animated: true)
    }
    
}
