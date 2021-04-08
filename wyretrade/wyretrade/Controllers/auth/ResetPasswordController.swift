//
//  ResetPasswordController.swift
//  wyretrade
//
//  Created by maxus on 3/6/21.
//

import Foundation
import UIKit
import UITextField_Shake
import NVActivityIndicatorView

class ResetPasswordController: UIViewController, UITextFieldDelegate, NVActivityIndicatorViewable {

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
    
    var user = UserAuthModel(fromDictionary: ["id": "", "first_name": "", "last_name": "", "email": "", "otp": ""] as! [String: Any])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func actionSubmit(_ sender: Any) {
        print(user)
        guard let otp = txtOtp.text else {
                return
            }
        if otp != user.otp! {
            self.showToast(message: "Not match otp")
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
            return
        }
        if confirmPassword == "" {
            self.txtConfirmPassword.shake(6, withDelta: 10, speed: 0.06)
            return
        }
        let param : [String: Any] = [
           "password": password,
            "password_confirmation": confirmPassword,
            "id": user.id!
       ]
        print(param)
        self.startAnimating()
        RequestHandler.resetPassword(parameter: param as NSDictionary, success: { (successResponse) in
            self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            self.showToast(message: dictionary["message"] as! String)
            
                let confirmationVC = self.storyboard?.instantiateViewController(withIdentifier: "SigninController") as! SigninController
                self.navigationController?.pushViewController(confirmationVC, animated: true)
            
        }) { (error) in
                        self.stopAnimating()
            let alert = Alert.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
}
