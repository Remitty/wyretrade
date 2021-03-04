//
//  HomeController.swift
//  wyretrade
//
//  Created by maxus on 3/1/21.
//

import UIKit
import MaterialComponents

class HomeController: UIViewController
//                      , UITableViewDelegate, UITableViewDataSource, NewsViewParameterDelegate
{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 0
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let section = indexPath.section
//        return UITableViewCell()
//    }
//
//    func paramData(param: NSDictionary) {
//        return nil
//    }
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var usdcBalance: UILabel!
    
    @IBOutlet weak var balanceCard: MDCCard!
    @IBOutlet weak var payCard: MDCCard!
    @IBOutlet weak var contactCard: MDCCard!
    
    @IBOutlet weak var newsTable: UITableView!
//    {
//        didSet {
//            newsTable.delegate = self
//            newsTable.dataSource = self
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func payCardClickAction(_ sender: Any) {
    }
    @IBAction func contactCardClickAction(_ sender: Any) {
    }
}

