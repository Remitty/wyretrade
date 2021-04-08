//
//  ForgotPasswordController.swift
//  wyretrade
//
//  Created by maxus on 3/6/21.
//

import Foundation
import UIKit
import UITextField_Shake
import NVActivityIndicatorView

class ForgotPasswordController: UIViewController, UITextFieldDelegate, NVActivityIndicatorViewable {

    @IBOutlet weak var txtEmail: UITextField! {
        didSet {
            txtEmail.delegate = self
        }
    }
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


    @IBAction func actionBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func actionNext(_ sender: Any) {
        guard let email = txtEmail.text else {
                return
            }
        if email == "" {
            self.txtEmail.shake(6, withDelta: 10, speed: 0.06)
            return
        }
        else if !email.isValidEmail {
            self.txtEmail.shake(6, withDelta: 10, speed: 0.06)
            return
        }
        let param : [String: Any] = [
           "email": email
       ]
        self.startAnimating()
        RequestHandler.forgotPassword(parameter: param as NSDictionary, success: { (successResponse) in
            self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            self.showToast(message: dictionary["message"] as! String)
            
            if let userData = dictionary["user"] as? [String:Any] {
                let user = UserAuthModel(fromDictionary: userData)
                let confirmationVC = self.storyboard?.instantiateViewController(withIdentifier: "ResetPasswordController") as! ResetPasswordController
                confirmationVC.user = user
                
                self.navigationController?.pushViewController(confirmationVC, animated: true)
                
            }
                
                
            
           
        }) { (error) in
                        self.stopAnimating()
            let alert = Alert.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
        
    }
}
