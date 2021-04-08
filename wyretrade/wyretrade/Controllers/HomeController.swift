//
//  HomeController.swift
//  wyretrade
//
//  Created by maxus on 3/1/21.
//

import UIKit
import MaterialComponents
import NVActivityIndicatorView
//import SlideMenuControllerSwift

class HomeController: UIViewController, NVActivityIndicatorViewable {
    
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var usdcBalance: UILabel!
    
    @IBOutlet weak var balanceCard: MDCCard!
    @IBOutlet weak var payCard: UIView!
    @IBOutlet weak var contactCard: UIView!
    
    @IBOutlet weak var newsTable: UITableView!
    {
        didSet {
            newsTable.delegate = self
            newsTable.dataSource = self
            newsTable.showsVerticalScrollIndicator = false
//            newsTable.separatorColor = UIColor.darkGray
//            newsTable.separatorStyle = .singleLineEtched
            newsTable.register(UINib(nibName: "NewsView", bundle: nil), forCellReuseIdentifier: "NewsView")
        }
    }

    var newsList = [NewsModel]()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        var data = defaults.object(forKey: "userAuthData")
        let objUser = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as! [String: Any]
        let userAuth = UserAuthModel(fromDictionary: objUser)

        self.userName.text = userAuth.first_name
        
        self.addLeftBarButtonWithImage(UIImage(named: "ic_menu")!)
        
        payCard.isUserInteractionEnabled = true
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(HomeController.payCardClick))
        payCard.addGestureRecognizer(tap1)
        
        contactCard.isUserInteractionEnabled = true
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(HomeController.contactCardClick))
        contactCard.addGestureRecognizer(tap2)
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
//       self.navigationController?.isNavigationBarHidden = true
       
       self.loadData()
       
    }
    
    func loadData() {
        
        self.startAnimating()
//                    self.showLoader()
        let param : [String : Any] = [:]
        RequestHandler.getHome(parameter: param as NSDictionary, success: { (successResponse) in
                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            var news : NewsModel!
            
            if let newsData = dictionary["news"] as? [[String:Any]] {
                self.newsList = [NewsModel]()
                for item in newsData {
                    news = NewsModel(fromDictionary: item)
                    self.newsList.append(news)
                }
                self.newsTable.reloadData()
            }

            self.usdcBalance.text = NumberFormat.init(value: dictionary["usdc_balance"] as! Double, decimal: 4).description
                    
                
            }) { (error) in
                        self.stopAnimating()
                let alert = Alert.showBasicAlert(message: error.message)
                        self.presentVC(alert)
            }
        
    }
    
    @objc func payCardClick(sender: UITapGestureRecognizer) {
        let payVC = self.storyboard?.instantiateViewController(withIdentifier: "USDCPayController") as! USDCPayController
        self.navigationController?.pushViewController(payVC, animated: true)
        
    }
    @objc func contactCardClick(sender: UITapGestureRecognizer) {
        let contactVC = self.storyboard?.instantiateViewController(withIdentifier: "USDCAddContactController") as! USDCAddContactController
        self.navigationController?.pushViewController(contactVC, animated: true)
    }
}

extension HomeController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NewsView = tableView.dequeueReusableCell(withIdentifier: "NewsView", for: indexPath) as! NewsView
        let news = newsList[indexPath.row]
        cell.title.text = news.title
        cell.summary.text = news.description
        cell.date.text = news.date
        cell.logo.load(url: URL(string:news.image)!)
        
        return cell
    }
}
