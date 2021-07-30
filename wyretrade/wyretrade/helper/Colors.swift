//
//  Colors.swift
//  wyretrade
//
//  Created by brian on 7/29/21.
//

import Foundation
import UIKit

enum Colors {

    case red
    case orange
    case yellow
    case green
    case tealBlue
    case blue
    case purple
    case pink

    var uiColor: UIColor {
        switch self {
        case .red:
            return UIColor(red: 255/255, green: 59/255, blue: 48/255, alpha: 1)
        
        case .orange:
            return UIColor(red: 255/255, green: 149/255, blue: 0/255, alpha: 1)
        case .yellow:
            return UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1)
        case .green:
            return UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        case .tealBlue:
            return UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 1)
        case .blue:
            return UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        case .purple:
            return UIColor(red: 88/255, green: 86/255, blue: 214/255, alpha: 1)
        case .pink:
            return UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1)
        }
    }

}

extension UIColor {
    static let systemBlue = UIColor(red: 6/255, green: 42/255, blue: 120/255, alpha: 1)
    static let systemGreen = UIColor(red: 0/255, green: 143/255, blue: 0/255, alpha: 1)
    static let green = UIColor(red: 0/255, green: 143/255, blue: 0/255, alpha: 1)
    static let systemRed = UIColor(red: 238/255, green: 32/255, blue: 77/255, alpha: 1)
    static let red = UIColor(red: 238/255, green: 32/255, blue: 77/255, alpha: 1)
    static let systemPurple = UIColor(red: 252/255, green: 94/255, blue: 48/255, alpha: 1)
    static let systemOrange = UIColor(red: 255/255, green: 79/255, blue: 0/255, alpha: 1)
    // etc
}
