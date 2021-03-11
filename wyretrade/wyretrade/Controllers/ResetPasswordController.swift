//
//  ResetPasswordController.swift
//  wyretrade
//
//  Created by maxus on 3/6/21.
//

import Foundation
import UIKit
import UITextField_Shake

class ResetPasswordController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtOtp: UITextField! {
        didSet {
            txtOtp.delegate = self
        }
    }
    @IBOutlet weak var txtPassword: UITextField! {
        didSet {
            txtPassword.delegate = self
        }
    }
    @IBOutlet weak var txtConfirmPassword: UITextField! {
        didSet {
            txtConfirmPassword.delegate = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func actionSubmit(_ sender: Any) {
        guard let otp = txtOtp.text else {
                return
            }
        guard let password = txtPassword.text else {
               return
           }
        guard let confirmPassword = txtConfirmPassword.text else {
               return
           }
        if password == "" {
            self.txtPassword.shake(6, withDelta: 10, speed: 0.06)
        }
        if confirmPassword == "" {
            self.txtConfirmPassword.shake(6, withDelta: 10, speed: 0.06)
        }
        let param : [String: Any] = [
           "password": password,
            "confirmed_password": confirmPassword,
//            "id": self.user_id
       ]
//        self.showLoader()
        RequestHandler.forgotPassword(parameter: param as NSDictionary, success: { (successResponse) in
//            self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            let success = dictionary["success"] as! Bool
            if success {
                let confirmationVC = self.storyboard?.instantiateViewController(withIdentifier: "ResetPasswordController") as! ResetPasswordController
                self.navigationController?.pushViewController(confirmationVC, animated: true)
            }
            else {
                let alert = Constants.showBasicAlert(message: dictionary["message"] as! String)
                self.presentVC(alert)
            }
        }) { (error) in
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
}
