//
//  DatePicker.swift
//  wyretrade
//
//  Created by brian on 3/30/21.
//

import Foundation
import UIKit

extension UIDatePicker {

   func setDate(from string: String, format: String = "yyyy-MM-dd", animated: Bool = true) {

      let formater = DateFormatter()

      formater.dateFormat = format

      let date = formater.date(from: string) ?? Date()

      setDate(date, animated: animated)
   }
    
    open override var description: String {
        let formater = DateFormatter()

        formater.dateFormat = "yyyy-MM-dd"
        
        return formater.string(from: self.date)
    }
}
