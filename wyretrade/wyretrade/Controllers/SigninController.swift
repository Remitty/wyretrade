//
//  SigninController.swift
//  wyretrade
//
//  Created by maxus on 3/5/21.
//

import Foundation
import UIKit

class SigninController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var btnSubmit: MDCButton!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnForgotPassword: UIButton!
    
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
    
    func login() {
        guard let email = txtEmail.text else {
                    return
                }
                guard let password = txtPassword.text else {
                    return
                }
                if email == "" {
                    self.txtEmail.shake(6, withDelta: 10, speed: 0.06)
                }
                else if !email.isValidEmail {
                    self.txtEmail.shake(6, withDelta: 10, speed: 0.06)
                }
                else if password == "" {
                     self.txtPassword.shake(6, withDelta: 10, speed: 0.06)
                }
                else {
                    let param : [String : Any] = [
                                                    "email" : email,
                                                    "password": password
                                                ]
                    
//                    self.showLoader()
                    RequestHandler.loginUser(parameter: parameters , success: { (successResponse) in
//                        self.stopAnimating()
                        if successResponse.success {
                            if self.isVerifyOn && successResponse.data.isAccountConfirm == false {
                                let alert = AlertView.prepare(title: "", message: successResponse.message, okAction: {
                                    let confirmationVC = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
                                    confirmationVC.isFromVerification = true
                                    confirmationVC.user_id = successResponse.data.id
                                    self.navigationController?.pushViewController(confirmationVC, animated: true)
                                })
                                self.presentVC(alert)
                            } else {
                                self.defaults.set(true, forKey: "isLogin")
                                self.defaults.synchronize()
                                self.appDelegate.moveToHome()
                            }
                        } else {
                            let alert = Constants.showBasicAlert(message: successResponse.message)
//                            self.presentVC(alert)
                        }
                    }) { (error) in
                        let alert = Constants.showBasicAlert(message: error.message)
//                                self.presentVC(alert)
                    }
                }
    }
    
    @IBAction func submit(_ sender: Any) {
        self.login()
    }
    
    @IBAction func actionRegister(_ sender: Any) {
    }
    
    @IBAction func actionForgotPassword(_ sender: Any) {
    }
}
