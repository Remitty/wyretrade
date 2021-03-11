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

    var newsList : [NewsModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        var data = defaults.object(forKey: "userAuthData")
        let objUser = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as! [String: Any]
        let userAuth = UserAuthModel(fromDictionary: objUser)

        self.userName.text = userAuth.first_name 
        self.loadData()
        
    }

    func loadData() {
        
                    
//                    self.showLoader()
        RequestHandler.getHome(nil, success: { (successResponse) in
//                        self.stopAnimating()
                let dictionary = successResponse as! [String: Any]
                let success = dictionary["success"] as! Bool
                var news : NewsModel!
                if success {
                    if let newsData = dictionary["news"] as? [String:Any] {
                        for item in newsData {
                            news = NewsModel(fromDictionary: item)
                            newsList.append(news)
                        }
                    }

                    self.usdcBalance.text = dictionary["usdc_balance"] as? String
                    
                } else {
                    let alert = Constants.showBasicAlert(message: dictionary["message"] as! String)
                    self.presentVC(alert)
                }
            }) { (error) in
                let alert = Constants.showBasicAlert(message: error.message)
                        self.presentVC(alert)
            }
        }
    }


    @IBAction func payCardClickAction(_ sender: Any) {
    }
    @IBAction func contactCardClickAction(_ sender: Any) {
    }
}

