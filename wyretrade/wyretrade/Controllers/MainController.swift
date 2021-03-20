//
//  ViewController.swift
//  wyretrade
//
//  Created by maxus on 2/28/21.
//

import UIKit
import SlideMenuControllerSwift

class MainController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       self.navigationController?.isNavigationBarHidden = true
        
   }

   override func viewWillDisappear(_ animated: Bool) {
       super.viewWillDisappear(animated)
       self.navigationController?.isNavigationBarHidden = false
   }


}

