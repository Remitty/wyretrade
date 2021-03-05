//
//  StocksDepositController.swift
//  wyretrade
//
//  Created by maxus on 3/4/21.
//

import Foundation
import UIKit

class StocksDepositController: UITabBarController {

    @IBOutlet weak var topbar: UITabBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        UIApplication.shared.statusBarFrame.size.height
        topbar.frame = CGRect(x: 0, y:  topbar.frame.size.height, width: topbar.frame.size.width, height: topbar.frame.size.height)
    }


}
