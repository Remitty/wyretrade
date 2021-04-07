//
//  ProfileEditController.swift
//  wyretrade
//
//  Created by maxus on 3/3/21.
//

import Foundation
import UIKit
import stellarsdk

class ProfileEditController: UIViewController, UITextFieldDelegate {
    
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
    @IBOutlet weak var txtPhone: UITextField! {
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
    
    var hasStellar: Bool = false
    var stellarBaseSecret: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
//        self.loadProfile()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
//       self.navigationController?.isNavigationBarHidden = true
       
       self.loadProfile()
       
    }
    
    func loadProfile() {
        let param = [:] as! NSDictionary
        RequestHandler.getProfile(parameter: param as NSDictionary, success: { (successResponse) in
//                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            self.stellarBaseSecret = dictionary["stellar_base_secret"] as? String
            self.hasStellar = dictionary["has_stellar"] as! Bool
            
            var user : UserModel!
            
            if let userData = dictionary["user"] as? [String:Any] {
                
                user = UserModel(fromDictionary: userData)
                self.txtFirstName.text = user.first_name
                self.txtLastName.text = user.last_name
                self.txtEmail.text = user.email
                self.txtCity.text = user.city
                self.dobPicker.setDate(from: user.dob)
                self.txtPhone.text = user.phone
                self.txtCountry.text = user.country
                self.txtNationality.text = user.national
                self.txtAddress1.text = user.address
                self.txtAddress2.text = user.address2
                self.txtPostalCode.text = user.postal_code
                
                
            }
                
            
        }) { (error) in
            let alert = Alert.showBasicAlert(message: error.message)
                    self.presentVC(alert)
        }
    }
    
    func submitUpdate(param: NSDictionary) {
        RequestHandler.profileUpdate(parameter: param, success: { (successResponse) in
//                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            let success = dictionary["success"] as! Bool
//            var user : UserAuthModel!
            if success {
                
                self.showToast(message: "Updated successfully.")
            } else {
                let alert = Alert.showBasicAlert(message: dictionary["message"] as! String)
                self.presentVC(alert)
            }
        }) { (error) in
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
        sdk.accounts.getAccountDetails(accountId: sourceAccountKeyPair.accountId) { (response) -> (Void) in
            switch response {
                case .success(let accountResponse): // source account successfully loaded.
                    do {
                    // build a create account operation.
                        let createAccount = CreateAccountOperation(sourceAccountId: sourceAccountKeyPair.accountId, destination: destinationKeyPair, startBalance: 10.0)
                        

                        // build a transaction that contains the create account operation.
                    let transaction = try Transaction(sourceAccount: accountResponse,
                                        operations: [createAccount],
                                        memo: Memo.none,
                                        timeBounds:nil)

                    // sign the transaction.
                    try! transaction.sign(keyPair: sourceAccountKeyPair, network: .public)

                        // submit the transaction to the stellar network.
                    try sdk.transactions.submitTransaction(transaction: transaction) { (response) -> (Void) in
                        switch response {
                        case .success(_):
                            print("Account successfully created.")
                            let param: NSDictionary = [
                                "first_name": self.txtFirstName.text!,
                                "last_name": self.txtLastName.text!,
                                "email": self.txtEmail.text!,
                                "mobile": self.txtPhone.text!,
                                "address": self.txtAddress1.text!,
                                "address2": self.txtAddress2.text!,
                                "country": self.txtCountry.text!,
                                "city": self.txtCity.text!,
                                "region": self.txtNationality.text!,
                                "dob": self.dobPicker.description,
                                "postalcode": self.txtPostalCode.text!,
                                "stellar_account_id": destinationKeyPair.accountId,
                                "stellar_secret_seed": destinationKeyPair.secretSeed!
                            ]
                            self.submitUpdate(param: param)
                        case .failure(let error):
                            StellarSDKLog.printHorizonRequestErrorMessage(tag:"Create account error", horizonRequestError: error)
                        default:
                            print("stelalr depost no data")
                        }
                    }
                } catch {
                    // ...
                }
            case .failure(let error): // error loading account details
                    StellarSDKLog.printHorizonRequestErrorMessage(tag:"Account detail Error:", horizonRequestError: error)
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
        if txtPhone.text == "" {
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
        
        if hasStellar {
            let param: NSDictionary = [
                "first_name": txtFirstName.text!,
                "last_name": txtLastName.text!,
                "email": txtEmail.text!,
                "mobile": txtPhone.text!,
                "address": txtAddress1.text!,
                "address2": txtAddress2.text!,
                "country": txtCountry.text!,
                "city": txtCity.text!,
                "region": txtNationality.text!,
                "dob": dobPicker.description,
                "postalcode": txtPostalCode.text!
            ]
            self.submitUpdate(param: param)
        } else {
            createStellarAccount()
        }
        
        
    }
}
