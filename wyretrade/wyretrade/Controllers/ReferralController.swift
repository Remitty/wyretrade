//
//  ReferralController.swift
//  wyretrade
//
//  Created by brian on 6/22/21.
//

import Foundation
import UIKit
import MessageUI
import FirebaseDynamicLinks

class ReferralController: UIViewController, MFMailComposeViewControllerDelegate {
    
    var invitationUrl: URL!
    
    
    @IBOutlet weak var btnInvite: UIButton! {
        didSet {
            btnInvite.round()
        }
    }
    
    override func viewDidLoad() {
        DynamicLinks.performDiagnostics(completion: nil)
    }
    
    
    @IBAction func actionInvite(_ sender: Any) {
        let defaults = UserDefaults.standard
        let data = UserDefaults.standard.object(forKey: "userAuthData")
        let objUser = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as! [String: Any]
        let userAuth = UserAuthModel(fromDictionary: objUser)
        
        let link = URL(string: "https://wyretrade.com/?invitedby=\(userAuth.id!)")!
        let referralLink = DynamicLinkComponents(link: link, domainURIPrefix: "https://wyretrade.page.link")
        

        referralLink?.iOSParameters = DynamicLinkIOSParameters(bundleID: "com.wyretrade")
        referralLink?.iOSParameters?.minimumAppVersion = "1.1.1"
        referralLink?.iOSParameters?.appStoreID = "346357857"

        referralLink?.androidParameters = DynamicLinkAndroidParameters(packageName: "com.wyre.trade")
        referralLink?.androidParameters?.minimumVersion = 17

        referralLink?.shorten { (shortURL, warnings, error) in
          if let error = error {
            print("error")
            print(error.localizedDescription)
            self.showToast(message: error.localizedDescription)
            return
          }
            print(shortURL?.absoluteURL)
          self.invitationUrl = shortURL!
            
            if self.invitationUrl != nil {
                let subject = "\(userAuth.first_name) \(userAuth.last_name) ivite you to wyretrade!"
                let invitationLink = self.invitationUrl
                let msg = "<p>Please use this very good app! Use my referer link: <a href=\"\(invitationLink?.absoluteString)\"></a>!</p>"

                if !MFMailComposeViewController.canSendMail() {
                    self.showToast(message: "Can't send email on this device")
                  return
                }
                let mailer = MFMailComposeViewController()
                mailer.mailComposeDelegate = self
                mailer.setSubject(subject)
                mailer.setMessageBody(msg, isHTML: true)
                self.present(mailer, animated: true, completion: nil)
            } else {
                print("No invitation url")
            }
        }
        
        
        
    }
    
    
}
