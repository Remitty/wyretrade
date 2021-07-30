//
//  VerifyPhoneNumberController.swift
//  wyretrade
//
//  Created by brian on 4/9/21.
//

import Foundation
import UIKit
import PhoneNumberKit
import NVActivityIndicatorView
import FlagPhoneNumber
import FirebaseAuth

class VerifyPhoneNumberController: UIViewController, NVActivityIndicatorViewable {
    @IBOutlet var phoneTextFiled: FPNTextField! {
        didSet {
            phoneTextFiled.delegate = self
        }
    }
    @IBOutlet weak var btnSend: UIButton!
    
    var delegate: VerifyCodeControllerDelegate!
    
    var phone : String!
    
    
    var listController: FPNCountryListViewController = FPNCountryListViewController(style: .grouped)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.initPhoneNumberKit()
        
        self.flagPhoneNumber()
       
    }

    func initPhoneNumberKit() {
////        phoneTextFiled.delegate = self
//        phoneTextFiled.withFlag = true
//        phoneTextFiled.withPrefix = true
//        phoneTextFiled.withExamplePlaceholder = true
////        phoneTextFiled.becomeFirstResponder()
//        phoneTextFiled.withDefaultPickerUI = true
    }
    
    func flagPhoneNumber() {
        phoneTextFiled.setFlag(countryCode: .US)
        phoneTextFiled.displayMode = .list // .picker by default
        listController.setup(repository: phoneTextFiled.countryRepository)
        listController.didSelect = { [weak self] country in
            self?.phoneTextFiled.setFlag(countryCode: country.code)
        }
    }
    
    func verifyPhone() {
        
        self.startAnimating()
        PhoneAuthProvider.provider().verifyPhoneNumber(self.phone, uiDelegate: nil) { (verificationID, error) in
            self.stopAnimating()
              if let error = error {
                    let alert = Alert.showBasicAlert(message: error.localizedDescription)
                            self.presentVC(alert)
                    return
              }
          // Sign in using the verificationID and the code sent to the user
          // ...
            print("phone verification code:" + verificationID!)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerifyCodeController") as! VerifyCodeController
            vc.delegate = self.delegate
            vc.verificationID = verificationID
            vc.phone = self.phone
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func actionSend(_ sender: Any) {
        self.verifyPhone()
//        let phoneNumberKit = PhoneNumberKit()
//        do {
//            let phone = phoneTextFiled.text!
//            if phone != "" {
//                let phoneNumber = try phoneNumberKit.parse(phone)
//                phoneNumberKit.format(phoneNumber, toType: .e164, withPrefix: true)
//                print(phoneNumber.numberString)
//                print(phoneNumber.countryCode)
//                print(phoneNumber.nationalNumber)
//                print(phoneNumber.numberExtension)
//                print(phoneNumber.type)
//            }
//        } catch {
//            print("phonenumber kit exception")
//        }
        
    }
}

extension VerifyPhoneNumberController: FPNTextFieldDelegate {

   /// The place to present/push the listController if you choosen displayMode = .list
   func fpnDisplayCountryList() {
        
        
        let navigationViewController = UINavigationController(rootViewController: listController)
      
        self.present(navigationViewController, animated: true, completion: nil)
   }

   /// Lets you know when a country is selected
   func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
      print(name, dialCode, code) // Output "France", "+33", "FR"
   }

   /// Lets you know when the phone number is valid or not. Once a phone number is valid, you can get it in severals formats (E164, International, National, RFC3966)
   func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
    
      if isValid {
         // Do something...
         print(textField.getFormattedPhoneNumber(format: .E164))           // Output "+33600000001"
         print(textField.getFormattedPhoneNumber(format: .International))  // Output "+33 6 00 00 00 01"
         print(textField.getFormattedPhoneNumber(format: .National))       // Output "06 00 00 00 01"
         print(textField.getFormattedPhoneNumber(format: .RFC3966))        // Output "tel:+33-6-00-00-00-01"
         print(textField.getRawPhoneNumber())                               // Output "600000001"
        phone = textField.getFormattedPhoneNumber(format: .E164)!
        
        self.btnSend.isEnabled = true
      } else {
         // Do something...
      }
   }
}
