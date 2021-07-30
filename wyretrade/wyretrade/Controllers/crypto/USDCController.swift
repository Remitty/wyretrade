//
//  USDCController.swift
//  wyretrade
//
//  Created by brian on 6/22/21.
//

import Foundation
import UIKit

class USDCController: UIViewController {
    
    @IBOutlet weak var payCard: UIView!
    @IBOutlet weak var contactCard: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        payCard.isUserInteractionEnabled = true
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(USDCController.payCardClick))
        payCard.addGestureRecognizer(tap1)
        
        contactCard.isUserInteractionEnabled = true
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(USDCController.contactCardClick))
        contactCard.addGestureRecognizer(tap2)
        
    }
    
    @objc func payCardClick(sender: UITapGestureRecognizer) {
        let payVC = self.storyboard?.instantiateViewController(withIdentifier: "USDCPayController") as! USDCPayController
        self.navigationController?.pushViewController(payVC, animated: true)
        
    }
    @objc func contactCardClick(sender: UITapGestureRecognizer) {
        let contactVC = self.storyboard?.instantiateViewController(withIdentifier: "USDCAddContactController") as! USDCAddContactController
        self.navigationController?.pushViewController(contactVC, animated: true)
    }
    
}
