//
//  StringValidate.swift
//  wyretrade
//
//  Created by maxus on 3/10/21.
//

import Foundation

extension String {
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: self)
    }
}

extension String {
    var isValidPhone: Bool {
        let inverseSet = NSCharacterSet(charactersIn:"+0123456789").inverted
        let components = self.components(separatedBy: inverseSet)
        let filtered = components.joined(separator: "")
        
        return self == filtered
    }
}

extension String {
    
    enum RegularExpressions: String {
        case phone = "^\\s*(?:\\+?(\\d{1,3}))?([-. (]*(\\d{3})[-. )]*)?((\\d{3})[-. ]*(\\d{2,4})(?:[-.x ]*(\\d+))?)\\s*$"
    }
    
    func isValid(regex: RegularExpressions) -> Bool {
        return isValid(regex: regex.rawValue)
    }
    
    func isValid(regex: String) -> Bool {
        let matches = range(of: regex, options: .regularExpression)
        return matches != nil
    }
    
    func onlyDigits() -> String {
        let filtredUnicodeScalars = unicodeScalars.filter{CharacterSet.decimalDigits.contains($0)}
        return String(String.UnicodeScalarView(filtredUnicodeScalars))
    }
    
    
}

extension String {
    var date: String {
        let start = self.index(self.startIndex, offsetBy: 0)
        let end = self.index(self.startIndex, offsetBy: 10)
        let sub = String(self[start..<end])
        
        return sub
    }
}
