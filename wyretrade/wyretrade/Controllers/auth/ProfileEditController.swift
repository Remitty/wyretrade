//
//  ProfileEditController.swift
//  wyretrade
//
//  Created by maxus on 3/3/21.
//

import Foundation
import UIKit
import stellarsdk
import NVActivityIndicatorView
import FlagPhoneNumber

class ProfileEditController: UIViewController, UITextFieldDelegate, NVActivityIndicatorViewable {
    
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
    @IBOutlet weak var txtPhone: FPNTextField! {
        didSet {
            txtPhone.delegate = self
        }
    }
//    @IBOutlet weak var txtDob: UITextField! {
//        didSet {
//            txtDob.delegate = self
//        }
//    }
    
    @IBOutlet weak var dobPicker: UIDatePicker!
    
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
    @IBOutlet weak var btnUpdate: UIButton! {
        didSet {
            btnUpdate.round()
        }
    }
    
    var hasStellar: Bool = false
    var stellarBaseSecret: String!
    var isComplete = false
    
    var phone = ""
    var countryCode = "+1"
    
    var listController: FPNCountryListViewController = FPNCountryListViewController(style: .grouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.flagPhoneNumber()
//        self.loadProfile()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
//       self.navigationController?.isNavigationBarHidden = true
        if !isComplete {
            self.loadProfile()
        }
       
    }
    
    func flagPhoneNumber() {
        txtPhone.setFlag(countryCode: .US)
        txtPhone.displayMode = .list // .picker by default
        listController.setup(repository: txtPhone.countryRepository)
        listController.didSelect = { [weak self] country in
            self?.txtPhone.setFlag(countryCode: country.code)
        }
    }
    
    func loadProfile() {
        self.startAnimating()
        let param = [:] as! NSDictionary
        RequestHandler.getProfile(parameter: param as NSDictionary, success: { (successResponse) in
                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
//            self.stellarBaseSecret = dictionary["stellar_base_secret"] as? String
//            self.hasStellar = dictionary["has_stellar"] as! Bool
            
            var user : UserModel!
            
            if let userData = dictionary["user"] as? [String:Any] {
                
                user = UserModel(fromDictionary: userData)
                self.txtFirstName.text = user.first_name
                self.txtLastName.text = user.last_name
                self.txtEmail.text = user.email
                self.txtCity.text = user.city
//                self.dobPicker.setDate(from: user.dob)
//                self.txtPhone.text = user.phone
                self.phone = user.phone
//                self.txtPhone.setFlag(countryCode: FPNCountryCode(rawValue: user.countryCode)!)
                self.countryCode = user.countryCode
                self.txtPhone.set(phoneNumber: user.countryCode + user.phone)
                self.txtCountry.text = user.state
                self.txtNationality.text = user.national
                self.txtAddress1.text = user.address
                self.txtAddress2.text = user.address2
                self.txtPostalCode.text = user.postal_code
                
                
            }
                
            
        }) { (error) in
                        self.stopAnimating()
            let alert = Alert.showBasicAlert(message: error.message)
                    self.presentVC(alert)
        }
    }
    
    func submitUpdate(param: NSDictionary) {
        self.startAnimating()
        RequestHandler.profileUpdate(parameter: param, success: { (successResponse) in
                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            let success = dictionary["success"] as! Bool
//            var user : UserAuthModel!
            if success {
                if !self.isComplete {
                    self.showToast(message: "Updated successfully.")
                } else {
                    self.isComplete = false
                    let alert = Alert.showBasicAlert(message: "You will get free PEPE token. \nInvite friends and earn more PEPE token.")
                    self.presentVC(alert)
                }
            } else {
                let alert = Alert.showBasicAlert(message: dictionary["message"] as! String)
                self.presentVC(alert)
            }
        }) { (error) in
                        self.stopAnimating()
            let alert = Alert.showBasicAlert(message: error.message)
                    self.presentVC(alert)
        }
    }
    
    func createStellarAccount() {
        let sdk = StellarSDK(withHorizonUrl: "https://horizon.stellar.org")
        let sourceAccountKeyPair = try! KeyPair(secretSeed: self.stellarBaseSecret)
//        let sourceAccountKeyPair = try! KeyPair(accountId: "GCRR74O62OV7E7WJSIEIWRKGBIDYNPBMN72QPIL6ZCNQ37VJELC6VG5E")
        print("Source account Id: " + sourceAccountKeyPair.accountId)
        // generate a random keypair representing the new account to be created.
        let destinationKeyPair = try! KeyPair.generateRandomKeyPair()
        print("Destination account Id: " + destinationKeyPair.accountId)
        print("Destination secret seed: " + destinationKeyPair.secretSeed)
        

        // load the source account from horizon to be sure that we have the current sequence number.
        self.startAnimating()
        sdk.accounts.getAccountDetails(accountId: sourceAccountKeyPair.accountId) { (response) -> (Void) in
            
            switch response {
                case .success(let accountResponse): // source account successfully loaded.
                    do {
                    // build a create account operation.
                        let createAccount = CreateAccountOperation(sourceAccountId: sourceAccountKeyPair.accountId, destination: destinationKeyPair, startBalance: 5.0)
                        
                        // build a transaction that contains the create account operation.
                        let transaction = try Transaction(sourceAccount: accountResponse,
                                        operations: [createAccount],
                                        memo: Memo.none,
                                        timeBounds:nil)

                        // sign the transaction.
                        try transaction.sign(keyPair: sourceAccountKeyPair, network: .public)

                            // submit the transaction to the stellar network.
                        try sdk.transactions.submitTransaction(transaction: transaction) { (response) -> (Void) in
                            switch response {
                                case .success(_):
                                    print("Account successfully created.")
                                    self.addTrustLine(keyPair: destinationKeyPair)
                                case .failure(let error):
                                    StellarSDKLog.printHorizonRequestErrorMessage(tag:"Create account error", horizonRequestError: error)
                                    self.stopAnimating()
                                default:
                                    print("stelalr depost no data")
                            }
                    }
                } catch {
                    // ...
                    print("stellar account create exception")
                    self.stopAnimating()
                }
            case .failure(let error): // error loading account details
                    StellarSDKLog.printHorizonRequestErrorMessage(tag:"Account detail Error:", horizonRequestError: error)
                self.stopAnimating()
            }
        }
    }
    
    func addTrustLine(keyPair: KeyPair) {
        let sdk = StellarSDK(withHorizonUrl: "https://horizon.stellar.org")
        let sourceAccountKeyPair = keyPair
        print("Source account Id: " + sourceAccountKeyPair.accountId)

        let issuer = try! KeyPair(accountId: "GAH2T6DSKIIWTDRVGTFSYDIVQTJG4ZVUTQ6COFRUWSVFHHUBU5UDT7DO")
        
        let param: NSDictionary = [
            "first_name": self.txtFirstName.text!,
            "last_name": self.txtLastName.text!,
            "email": self.txtEmail.text!,
            "mobile": self.txtPhone.text!,
            "address": self.txtAddress1.text!,
            "address2": self.txtAddress2.text!,
//            "country": self.txtCountry.text!,
            "city": self.txtCity.text!,
            "region": self.txtNationality.text!,
//            "dob": self.dobPicker.description,
            "postalcode": self.txtPostalCode.text!,
            "stellar_account_id": keyPair.accountId,
            "stellar_secret_seed": keyPair.secretSeed!
        ]

        // load the source account from horizon to be sure that we have the current sequence number.
        self.startAnimating()
        sdk.accounts.getAccountDetails(accountId: sourceAccountKeyPair.accountId) { (response) -> (Void) in
            
            switch response {
                case .success(let accountResponse): // source account successfully loaded.
                    do {
                    // build a add trustline operation.
                        
                        let changeTrust = ChangeTrustOperation(sourceAccountId: sourceAccountKeyPair.accountId, asset: Asset(type: AssetType.ASSET_TYPE_CREDIT_ALPHANUM4, code: "PEPE", issuer: issuer)!)
                        // build a transaction that contains the create account operation.
                        let transaction = try Transaction(sourceAccount: accountResponse,
                                        operations: [changeTrust],
                                        memo: Memo.none,
                                        timeBounds:nil)

                        // sign the transaction.
                        try transaction.sign(keyPair: sourceAccountKeyPair, network: .public)

                            // submit the transaction to the stellar network.
                        try sdk.transactions.submitTransaction(transaction: transaction) { (response) -> (Void) in
                            switch response {
                                case .success(_):
                                    print("Created trustline successfully.")
                                    
                                    self.submitUpdate(param: param)
                                case .failure(let error):
                                    StellarSDKLog.printHorizonRequestErrorMessage(tag:"Create trustline error", horizonRequestError: error)
                                    self.stopAnimating()
                                default:
                                    print("stelalr trustline no data")
                            }
                    }
                } catch {
                    // ...
                    print("stellar create trustline exception")
                    self.stopAnimating()
                }
            case .failure(let error): // error loading account details
                    StellarSDKLog.printHorizonRequestErrorMessage(tag:"Account detail Error:", horizonRequestError: error)
                self.stopAnimating()
            }
        }
    }
    
    @IBAction func changedDate(_ sender: UIDatePicker) {
        print(sender.description)
        sender.setDate(from: sender.description)
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
        if self.phone == "" {
            txtPhone.shake(6, withDelta: 10, speed: 0.06)
            return
        }
//        if txtDob.text == "" {
//            txtDob.shake(6, withDelta: 10, speed: 0.06)
//            return
//        }
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
        
//        if hasStellar {
            let param: NSDictionary = [
                "first_name": txtFirstName.text!,
                "last_name": txtLastName.text!,
                "email": txtEmail.text!,
                "mobile": self.phone,
                "country_code": self.countryCode,
                "address1": txtAddress1.text!,
                "address2": txtAddress2.text!,
                "state": txtCountry.text!,
                "city": txtCity.text!,
                "region": txtNationality.text!,
//                "dob": dobPicker.description,
                "postalcode": txtPostalCode.text!
            ]
            self.submitUpdate(param: param)
//        } else {
//            createStellarAccount()
//        }
        
        
        
    }
}


extension ProfileEditController: FPNTextFieldDelegate {

   /// The place to present/push the listController if you choosen displayMode = .list
   func fpnDisplayCountryList() {
        
        
        let navigationViewController = UINavigationController(rootViewController: listController)
      
        self.present(navigationViewController, animated: true, completion: nil)
   }

   /// Lets you know when a country is selected
   func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
      print(name, dialCode, code) // Output "France", "+33", "FR"
        countryCode = dialCode
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
        phone = textField.getRawPhoneNumber()!
        
        
      } else {
         // Do something...
      }
   }
}
