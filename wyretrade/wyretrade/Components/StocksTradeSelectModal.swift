//
//  StocksTradeSelectModal.swift
//  wyretrade
//
//  Created by brian on 3/14/21.
//

import Foundation
import UIKit
import DLRadioButton

class StocksTradeSelectModal: UIViewController {

   
    @IBOutlet weak var rdMarket: DLRadioButton!
    @IBOutlet weak var rdLimit: DLRadioButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func testaction(_ sender: Any) {
        print("test")
    }
    
    @IBAction func actionMarket(_ sender: Any) {
        print("xanpool")
    }
    @IBAction func actionLimit(_ sender: Any) {
        print("ramper")
    }
}
