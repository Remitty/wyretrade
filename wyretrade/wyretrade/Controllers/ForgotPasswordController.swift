//
//  ForgotPasswordController.swift
//  wyretrade
//
//  Created by maxus on 3/6/21.
//

import Foundation
import UIKit
import UITextField_Shake

class ForgotPasswordController: UIViewController, UITextFieldDelegate {

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
        }
        else if !email.isValidEmail {
            self.txtEmail.shake(6, withDelta: 10, speed: 0.06)
        }
        let param : [String: Any] = [
           "email": email
       ]
//        self.showLoader()
        RequestHandler.forgotPassword(parameter: param as NSDictionary, success: { (successResponse) in
//            self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            let success = dictionary["success"] as! Bool
            if success {
                let dictionary = successResponse as! [String: Any]
                if let userData = dictionary["user"] as? [String:Any] {
                    let confirmationVC = self.storyboard?.instantiateViewController(withIdentifier: "ResetPasswordController") as! ResetPasswordController
//                    confirmationVC.user_id = userData.id
                    
                    self.navigationController?.pushViewController(confirmationVC, animated: true)
                    
                }
                
                
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
