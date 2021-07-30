//
//  CompleteWithdrawController.swift
//  wyretrade
//
//  Created by brian on 4/9/21.
//

import Foundation
import UIKit

class CompleteWithdrawController: UIViewController {
    
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lbSymbol: UILabel!
    @IBOutlet weak var lbAmount: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    
    @IBOutlet weak var btnReturn: UIButton! {
        didSet {
            btnReturn.round()
        }
    }
    
    var icon: String!
    var symbol: String!
    var amount: String!
    var address: String!
    
    override func viewDidLoad() {
        if icon != nil {
            imgIcon.load(url: URL(string: icon)!)
        }
        if symbol != nil {
            lbSymbol.text = symbol
        }
        lbAmount.text = amount
        lbAddress.text = address
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       self.navigationController?.isNavigationBarHidden = true
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
        
    }
    
    @IBAction func actionHome(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "CoinsController") as! CoinsController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension CoinWithdrawController {
    
}
