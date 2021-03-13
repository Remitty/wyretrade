//
//  Alert.swift
//  wyretrade
//
//  Created by maxus on 3/12/21.
//

import Foundation
import UIKit

class Alert {
    
    static func showBasicAlert (message: String) -> UIAlertController{
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        return alert
    }
    
    static func 
}
