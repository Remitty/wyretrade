//
//  LeftController.swift
//  wyretrade
//
//  Created by maxus on 3/7/21.
//

import Foundation
import SlideMenuControllerSwift
import NVActivityIndicatorView

enum MainMenu: Int {
    case stakecoin = 0
    case tradecryptos
    case linkwallet
    case mtnservice
    case prediction
    case cryptowithdraw
    case stockhistory
    case depositactivities
    case stocknews
    case support
    case logout
}

enum OtherMenues: Int {
    case support
    case logout
}

protocol changeOtherMenuesProtocol {
    func changeMenu(_ other: MainMenu )
}

class LeftController: UIViewController, UITableViewDelegate, UITableViewDataSource, changeOtherMenuesProtocol {
   

    //MARK:- Outlets
    @IBOutlet weak var imgProfilePicture: UIImageView! {
        didSet {
//            imgProfilePicture.round()
        }
    }
    
    @IBOutlet weak var containerViewImage: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.showsVerticalScrollIndicator = false
            tableView.separatorColor = UIColor.darkGray
            tableView.separatorStyle = .singleLineEtched
        }
    }
    
    //MARK:- Properties
    
    var defaults = UserDefaults.standard
    var mainMenus = ["Stake Coin", "Trade Cryptos", "Link Wallet", "MTN Service", "Prediction", "Crypto Withdraw", "Stock History", "Deposit Activities", "Stock News", "Support", "Logout"]
    var mainMenuImages = [#imageLiteral(resourceName: "xmt"),#imageLiteral(resourceName: "nav_trade"), #imageLiteral(resourceName: "nav_trading"),#imageLiteral(resourceName: "nav_smartphone"), #imageLiteral(resourceName: "nav_analysis"),#imageLiteral(resourceName: "nav_bitcoin"), #imageLiteral(resourceName: "nav_chart"),#imageLiteral(resourceName: "nav_credit"), #imageLiteral(resourceName: "nav_news"), #imageLiteral(resourceName: "nav_support"),#imageLiteral(resourceName: "nav_logout")]
    var otherMenus = ["Support", "Logout"]
    var othersArrayImages = [#imageLiteral(resourceName: "nav_support"),#imageLiteral(resourceName: "nav_logout")]
    
    var viewStakeCoin: UIViewController!
    var viewTradeCryptos: UIViewController!
    var viewLinkWallet: UIViewController!
    var viewMtnService: UIViewController!
    var viewPrediction: UIViewController!
    var viewCryptoWithdraw: UIViewController!
    var viewStockHistory: UIViewController!
    var viewDepositActivities: UIViewController!
    var viewStockNews: UIViewController!
    
    
    //Other Menues
    var viewSupport : UIViewController!
    var viewlogout: UIViewController!
    
    //MARK:- Application Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initializeViews()
        self.initializeOtherViews()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.setHeader()
    }
    
    fileprivate func initializeViews() {
        let stakecoinView = storyboard?.instantiateViewController(withIdentifier: "StakeController") as! StakeController
        self.viewStakeCoin = UINavigationController(rootViewController: stakecoinView)
        
        let tradeCryptosView = storyboard?.instantiateViewController(withIdentifier: "TradeCryptosController") as! TradeCryptosController
        self.viewTradeCryptos = UINavigationController(rootViewController: tradeCryptosView)
        
        let linkwalletView = storyboard?.instantiateViewController(withIdentifier: "LinkWalletController") as! LinkWalletController
        self.viewLinkWallet = UINavigationController(rootViewController: linkwalletView)
        
        let mtnView = storyboard?.instantiateViewController(withIdentifier: "MtnController") as! MtnController
        self.viewMtnService = UINavigationController(rootViewController: mtnView)
        
        let predictionView = storyboard?.instantiateViewController(withIdentifier: "PredictionController") as! PredictionController
        self.viewPrediction = UINavigationController(rootViewController: predictionView)

        let coinwithdrawView = storyboard?.instantiateViewController(withIdentifier: "CoinWithdrawController") as! CoinWithdrawController
        self.viewCryptoWithdraw = UINavigationController(rootViewController: coinwithdrawView)
        
        let stockshistoryView = storyboard?.instantiateViewController(withIdentifier: "StocksHistoryController") as! StocksHistoryController
        self.viewStockHistory = UINavigationController(rootViewController: stockshistoryView)
        
        let deposithistoryView = storyboard?.instantiateViewController(withIdentifier: "DepositHistoryController") as! DepositHistoryController
        self.viewDepositActivities = UINavigationController(rootViewController: deposithistoryView)
        
        let stocksnewsView = storyboard?.instantiateViewController(withIdentifier: "StocksNewsController") as! StocksNewsController
        self.viewStockNews = UINavigationController(rootViewController: stocksnewsView)
    }

    func initializeOtherViews() {
        let supportView = storyboard?.instantiateViewController(withIdentifier: "SupportController") as! SupportController
        self.viewSupport = UINavigationController(rootViewController: supportView)
    }
    
    func changeMenu(_ other: MainMenu) {
        switch other {
        case .stakecoin:
            self.slideMenuController()?.changeMainViewController(self.viewStakeCoin, close: true)
        case .tradecryptos:
            self.slideMenuController()?.changeMainViewController(self.viewTradeCryptos, close: true)
        case .linkwallet:
            self.slideMenuController()?.changeMainViewController(self.viewLinkWallet, close: true)
        case .mtnservice:
            self.slideMenuController()?.changeMainViewController(self.viewMtnService, close: true)
        case .prediction:
            self.slideMenuController()?.changeMainViewController(self.viewPrediction, close: true)
        case .cryptowithdraw:
            self.slideMenuController()?.changeMainViewController(self.viewCryptoWithdraw, close: true)
        case .stockhistory:
            self.slideMenuController()?.changeMainViewController(self.viewStockHistory, close: true)
        case .depositactivities:
            self.slideMenuController()?.changeMainViewController(self.viewDepositActivities, close: true)
        case .stocknews:
            self.slideMenuController()?.changeMainViewController(self.viewStockNews, close: true)
        case .support :
            self.slideMenuController()?.changeMainViewController(self.viewSupport, close: true)
        case .logout :
            let alert = Alert.showConfirmAlert(message: "Are you sure you want to logout?", handler: { (_) in self.logoutUser()})
            self.presentVC(alert)
            
        }
    }
    
    //MARK-: Logout user
    func logoutUser() {
        self.defaults.set(false, forKey: "isLogin")
        let signinController = storyboard?.instantiateViewController(withIdentifier: "SigninController") as! SigninController
        self.navigationController?.pushViewController(signinController, animated: true)
    }
    //MARK:- Table View Delegate Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 11
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LeftMenuCell = tableView.dequeueReusableCell(withIdentifier: "LeftMenuCell", for: indexPath) as! LeftMenuCell
        let row = indexPath.row
        
        cell.lblName.text = self.mainMenus[row]
        cell.imgPicture.image = self.mainMenuImages[row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = ""
        
        return title
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        
        let menu = MainMenu(rawValue: indexPath.row)!
        self.changeMenu(menu)
        
//        let obj = self.mainMenus[indexPath.row]
//        self.changeViewController(controllerName: obj)

    }
}
