//
//  SupportController.swift
//  wyretrade
//
//  Created by maxus on 3/5/21.
//

import Foundation
import UIKit
import MessageUI
import NVActivityIndicatorView

class SupportController: UIViewController, MFMailComposeViewControllerDelegate, NVActivityIndicatorViewable {
    
    var supportEmail = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //        self.addLeftBarButtonWithImage(UIImage(named: "ic_menu")!)
//        self.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func loadData() {
        self.startAnimating()
        let param : [String : Any] = [:]
                RequestHandler.getSupport(parameter: param as NSDictionary, success: { (successResponse) in
                                self.stopAnimating()
                    let dictionary = successResponse as! [String: Any]
                    
                    self.supportEmail = dictionary["contact_email"] as! String
                    
                    
                    }) { (error) in
                        self.stopAnimating()
                        let alert = Alert.showBasicAlert(message: error.message)
                                self.presentVC(alert)
                    }
    }

    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([self.supportEmail])
            mail.setMessageBody("<p>Message body!</p>", isHTML: true)

            present(mail, animated: true)
        } else {
            // show failure alert
            print("faild on emulator!")
        }
        
//
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    @IBAction func actionEmail(_ sender: Any) {
        self.sendEmail()
    }
}
