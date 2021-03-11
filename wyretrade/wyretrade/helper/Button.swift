//
//  Button.swift
//  wyretrade
//
//  Created by maxus on 3/10/21.
//

import Foundation
import UIKit

extension UIButton {
    func roundCornors(radius: CGFloat = 5) {
        layer.masksToBounds = true
        layer.cornerRadius = radius
        clipsToBounds = true
    }
}

extension UIButton {
    func circularButton() {
        layer.masksToBounds = false
        layer.cornerRadius = frame.width / 2
        clipsToBounds = true
    }
}
