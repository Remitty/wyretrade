//
//  VerifyCodeController.swift
//  wyretrade
//
//  Created by brian on 4/9/21.
//

import Foundation
import SwiftyCodeView
import RxSwift
import RxCocoa
import FirebaseAuth
import NVActivityIndicatorView

class VerifyCodeController: UIViewController, NVActivityIndicatorViewable {
    
    var delegate: VerifyCodeControllerDelegate!

    @IBOutlet weak var codeView: SwiftyCodeView!
    
    @IBOutlet weak var btnVerify: UIButton!
    
    var verificationID: String!
    var phone: String!
    var code: String!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        let codeLenght = codeView.length
        codeView.rx.code.map({$0.count == codeLenght})
            .bind(to: btnVerify.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    
    @IBAction func actionVerify(_ sender: UIButton) {
        
        self.startAnimating()

        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: codeView.code)
//
        Auth.auth().signIn(with: credential) { (authResult, error) in
            self.stopAnimating()
            if let error = error {
                self.showToast(message: "Invalid code")
                return
            }

//            self.showToast(message: "Success")

            self.delegate.passVerify()
        }
    }
    
    @IBAction func actionResend(_ sender: UIButton) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phone, uiDelegate: nil) { (verificationID, error) in
              if let error = error {
                    let alert = Alert.showBasicAlert(message: error.localizedDescription)
                            self.presentVC(alert)
                    return
              }
          // Sign in using the verificationID and the code sent to the user
          // ...
            print("phone verification code:" + verificationID!)
            self.showToast(message: "Send code again")
            
        }
    }
   
}

protocol VerifyCodeControllerDelegate {
    func passVerify()
}
