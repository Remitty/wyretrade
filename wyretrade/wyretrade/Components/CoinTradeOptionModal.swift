//
//  CoinTradeOptionModal.swift
//  wyretrade
//
//  Created by maxus on 3/12/21.
//

import Foundation
import UIKit
import DLRadioButton

class CoinTradeOptionModal: UIViewController {

   
    @IBOutlet weak var rdOnramper: DLRadioButton!
    @IBOutlet weak var rdRamp: DLRadioButton!
    @IBOutlet weak var rdXanpool: DLRadioButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func testaction(_ sender: Any) {
        print("test")
    }
    
    @IBAction func actionSanpool(_ sender: Any) {
        print("xanpool")
    }
    @IBAction func actionRamper(_ sender: Any) {
        print("ramper")
    }
}
