//
//  BankContactItem.swift
//  wyretrade
//
//  Created by brian on 3/22/21.
//

import Foundation
import UIKit

protocol BankContactParamDelegate {
    func deleteParam(param: NSDictionary)
}

class BankContactItem: UITableViewCell {
    
    @IBOutlet var lbAlias: UILabel!
    @IBOutlet var lbCurrency: UILabel!
    @IBOutlet var btnRemove: UIButton!
    
    var id = ""
    
    var delegate: BankContactParamDelegate!
    
    
    @IBAction func actionDelete(_ sender: Any) {
        let param: NSDictionary = ["param": id]
        delegate?.deleteParam(param: param)
    }
}
