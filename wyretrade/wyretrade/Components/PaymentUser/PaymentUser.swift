//
//  PaymentUser.swift
//  wyretrade
//
//  Created by maxus on 3/6/21.
//

import Foundation
import UIKit

protocol PaymentUserParameterDelegate {
    func paramData(param: NSDictionary)
}

class PaymentUser: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    
    var delegate: PaymentUserParameterDelegate?
    
    var contactId = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func actionDelete(_ sender: Any) {
        let param: [String: Any] = [
            "id": self.contactId
        ]
        self.delegate?.paramData(param: param as NSDictionary)
    }
}
