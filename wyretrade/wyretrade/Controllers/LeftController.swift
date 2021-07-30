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
    case usdc
    case linkwallet
    case mtnservice
    case stockhistory
    case depositactivities
    case friend
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
    
    @IBOutlet weak var lbUserName: UILabel!
    @IBOutlet weak var lbUserEmail: UILabel!
    
    
    //MARK:- Properties
    
    var defaults = UserDefaults.standard
    var mainMenus = ["Stake Coin", "Send USDC", "Link Wallet", "MTN Service", "Stock History", "Deposit Activities", "Invite Friend", "Support", "Logout"]
    var mainMenuImages = [#imageLiteral(resourceName: "logo"),#imageLiteral(resourceName: "nav_trade"), #imageLiteral(resourceName: "nav_trading"),#imageLiteral(resourceName: "nav_smartphone"), #imageLiteral(resourceName: "nav_chart"),#imageLiteral(resourceName: "nav_credit"), #imageLiteral(resourceName: "nav_trade"), #imageLiteral(resourceName: "nav_support"),#imageLiteral(resourceName: "nav_logout")]
    var otherMenus = ["Support", "Logout"]
    var othersArrayImages = [#imageLiteral(resourceName: "nav_support"),#imageLiteral(resourceName: "nav_logout")]
    
    var viewHome: UITabBarController!
    var viewStakeCoin: UIViewController!
    var viewTradeToken: UIViewController!
    var viewLinkWallet: UIViewController!
    var viewMtnService: UIViewController!
    var viewPrediction: UIViewController!
    var viewCryptoWithdraw: UIViewController!
    var viewStockHistory: UIViewController!
    var viewDepositActivities: UIViewController!
    var viewStockNews: UIViewController!
    var viewUSDC: UIViewController!
    var viewInvite: UIViewController!
    
    
    //Other Menues
    var viewSupport : UIViewController!
    var viewlogout: UIViewController!
    
    //MARK:- Application Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initializeViews()
        self.initializeOtherViews()
        
        let data = UserDefaults.standard.object(forKey: "userAuthData")
        let objUser = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as! [String: Any]
        let userAuth = UserAuthModel(fromDictionary: objUser)
        
        self.lbUserName.text = "\(userAuth.first_name!) \(userAuth.last_name!)"
        self.lbUserEmail.text = userAuth.email
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.setHeader()
    }
    
    fileprivate func initializeViews() {
        let mainView = storyboard?.instantiateViewController(withIdentifier: "MainController") as! MainController
        self.viewHome = mainView //UINavigationController(rootViewController: stakecoinView)
        
        let stakecoinView = storyboard?.instantiateViewController(withIdentifier: "StakeListController") as! StakeListController
        self.viewStakeCoin = stakecoinView//UINavigationController(rootViewController: stakecoinView)
        
        let TradeTokenView = storyboard?.instantiateViewController(withIdentifier: "TradeTokenController") as! TradeTokenController
        self.viewTradeToken = TradeTokenView//UINavigationController(rootViewController: TradeTokenView)
        
        let linkwalletView = storyboard?.instantiateViewController(withIdentifier: "LinkAccountController") as! LinkAccountController
        self.viewLinkWallet = linkwalletView//UINavigationController(rootViewController: linkwalletView)
        
        let mtnView = storyboard?.instantiateViewController(withIdentifier: "MtnController") as! MtnController
        self.viewMtnService = mtnView//UINavigationController(rootViewController: mtnView)
        
        let predictionView = storyboard?.instantiateViewController(withIdentifier: "PredictPagerVC") as! PredictPagerVC
        self.viewPrediction = predictionView//UINavigationController(rootViewController: predictionView)

        let coinwithdrawView = storyboard?.instantiateViewController(withIdentifier: "CoinWithdrawController") as! CoinWithdrawController
        self.viewCryptoWithdraw = coinwithdrawView//UINavigationController(rootViewController: coinwithdrawView)
        
        let stockshistoryView = storyboard?.instantiateViewController(withIdentifier: "StocksHistoryPagerVC") as! StocksHistoryPagerVC
        self.viewStockHistory = stockshistoryView//UINavigationController(rootViewController: stockshistoryView)
        
        let deposithistoryView = storyboard?.instantiateViewController(withIdentifier: "DepositHistoryController") as! DepositHistoryController
        self.viewDepositActivities = deposithistoryView//UINavigationController(rootViewController: deposithistoryView)
        
        let stocksnewsView = storyboard?.instantiateViewController(withIdentifier: "StocksNewsController") as! StocksNewsController
        self.viewStockNews = stocksnewsView//UINavigationController(rootViewController: stocksnewsView)
        
        let usdcView = storyboard?.instantiateViewController(withIdentifier: "USDCController") as! USDCController
        self.viewUSDC = usdcView//UINavigationController(rootViewController: stocksnewsView)
        
        let inviteView = storyboard?.instantiateViewController(withIdentifier: "ReferralController") as! ReferralController
        self.viewInvite = inviteView//UINavigationController(rootViewController: stocksnewsView)
    }

    func initializeOtherViews() {
        let supportView = storyboard?.instantiateViewController(withIdentifier: "SupportController") as! SupportController
        self.viewSupport = supportView//UINavigationController(rootViewController: supportView)
    }
    
    func changeMenu(_ other: MainMenu) {
        self.slideMenuController()?.closeLeft()
        switch other {
//        case .home:
//            self.slideMenuController()?.changeMainViewController(self.viewHome, close: true)
        case .stakecoin:
            self.navigationController?.pushViewController(viewStakeCoin, animated: true)
//            self.slideMenuController()?.changeMainViewController(self.viewStakeCoin, close: true)
        case .usdc:
            self.navigationController?.pushViewController(viewUSDC, animated: true)
//            self.slideMenuController()?.changeMainViewController(self.viewTradeToken, close: true)
        case .linkwallet:
            self.navigationController?.pushViewController(viewLinkWallet, animated: true)
//            self.slideMenuController()?.changeMainViewController(self.viewLinkWallet, close: true)
        case .mtnservice:
            self.navigationController?.pushViewController(viewMtnService, animated: true)
//            self.slideMenuController()?.changeMainViewController(self.viewMtnService, close: true)
//        case .prediction:
//            self.navigationController?.pushViewController(viewPrediction, animated: true)
//            self.slideMenuController()?.changeMainViewController(self.viewPrediction, close: true)
//        case .cryptowithdraw:
//            self.navigationController?.pushViewController(viewCryptoWithdraw, animated: true)
//            self.slideMenuController()?.changeMainViewController(self.viewCryptoWithdraw, close: true)
        case .stockhistory:
            self.navigationController?.pushViewController(viewStockHistory, animated: true)
//            self.slideMenuController()?.changeMainViewController(self.viewStockHistory, close: true)
        case .depositactivities:
            self.navigationController?.pushViewController(viewDepositActivities, animated: true)
//            self.slideMenuController()?.changeMainViewController(self.viewDepositActivities, close: true)
        case .friend:
            self.navigationController?.pushViewController(viewInvite, animated: true)
//            self.slideMenuController()?.changeMainViewController(self.viewStockNews, close: true)
        case .support :
            self.navigationController?.pushViewController(viewSupport, animated: true)
//            self.slideMenuController()?.changeMainViewController(self.viewSupport, close: true)
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
    
    @IBAction func actionEditProfile(_ sender: Any) {
        let profileView = storyboard?.instantiateViewController(withIdentifier: "ProfileController") as! ProfileController
        self.navigationController?.pushViewController(profileView, animated: true)
    }
    
    //MARK:- Table View Delegate Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 9
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
