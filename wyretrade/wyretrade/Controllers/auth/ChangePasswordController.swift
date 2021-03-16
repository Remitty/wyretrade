//
//  ChangePasswordController.swift
//  wyretrade
//
//  Created by maxus on 3/6/21.
//

import Foundation
import UIKit

class ChangePasswordController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtOldPw: UITextField! {
        didSet {
            txtOldPw.delegate = self
        }
    }
    @IBOutlet weak var txtNewPw: UITextField! {
        didSet {
            txtNewPw.delegate = self
        }
    }
    @IBOutlet weak var txtConfirmPw: UITextField! {
        didSet {
            txtConfirmPw.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func actionUpdate(_ sender: Any) {
        if txtOldPw.text == "" {
            txtOldPw.shake(6, withDelta: 10, speed: 0.06)
        }
        if txtNewPw.text == "" {
            txtNewPw.shake(6, withDelta: 10, speed: 0.06)
        }
        if txtConfirmPw.text == "" {
            txtConfirmPw.shake(6, withDelta: 10, speed: 0.06)
        }
        
        let param = [
            "password": txtNewPw.text,
            "password_confirm": txtConfirmPw.text,
            "old_password": txtOldPw.text
        ] as! NSDictionary
        
        RequestHandler.changePassword(parameter: param as NSDictionary, success: { (successResponse) in
//                        self.stopAnimating()
            self.showToast(message: "Changed successfully")
            
        }) { (error) in
            let alert = Alert.showBasicAlert(message: error.message)
                    self.presentVC(alert)
        }
    }
}
