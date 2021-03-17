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
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alert
    }
    
    static func showConfirmAlert (message: String, handler: @escaping (UIAlertAction)->Void) -> UIAlertController {
        let alert = UIAlertController(title: "Confirm", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: handler))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        return alert
    }
}
