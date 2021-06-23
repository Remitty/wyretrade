//
//  HomeController.swift
//  wyretrade
//
//  Created by maxus on 3/1/21.
//

import UIKit
import MaterialComponents
import NVActivityIndicatorView
import ImageSlideshow
//import SlideMenuControllerSwift

class HomeController: UIViewController, NVActivityIndicatorViewable {
  
    @IBOutlet weak var scroller: UIScrollView!   
    
    @IBOutlet weak var slideshow: ImageSlideshow!
    @IBOutlet weak var newsTable: UITableView!
    {
        didSet {
            newsTable.delegate = self
            newsTable.dataSource = self
            newsTable.showsVerticalScrollIndicator = false

            newsTable.register(UINib(nibName: "NewsView", bundle: nil), forCellReuseIdentifier: "NewsView")
        }
    }

    @IBOutlet weak var gainersTable: UITableView!
    {
        didSet {
            gainersTable.delegate = self
            gainersTable.dataSource = self
            gainersTable.showsVerticalScrollIndicator = false

            gainersTable.register(UINib(nibName: "TopStocksItem", bundle: nil), forCellReuseIdentifier: "TopStocksItem")
        }
    }
    
    @IBOutlet weak var losersTable: UITableView!
    {
        didSet {
            losersTable.delegate = self
            losersTable.dataSource = self
            losersTable.showsVerticalScrollIndicator = false

            losersTable.register(UINib(nibName: "TopStocksItem", bundle: nil), forCellReuseIdentifier: "TopStocksItem")
        }
    }
    
    
    
    var newsList = [NewsModel]()
    var topGainers = [TopStocksModel]()
    var topLosers = [TopStocksModel]()
    
    var sourceImages = [InputSource]()
        var localImages = [String]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        scroller.contentSize = CGSize(width: 400, height: 2300)
        
        self.addLeftBarButtonWithImage(UIImage(named: "ic_menu")!)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
//       self.navigationController?.isNavigationBarHidden = true
       
       self.loadData()
       
    }
    
    func imageSliderSetting() {
        for image in localImages {
            let alamofireSource = AlamofireSource(urlString: image.encodeUrl())!
            sourceImages.append(alamofireSource)
        }
        slideshow.backgroundColor = UIColor.white
        slideshow.slideshowInterval = 5.0
        slideshow.pageControlPosition = PageControlPosition.insideScrollView
        slideshow.pageControl.currentPageIndicatorTintColor = UIColor.white
        slideshow.pageControl.pageIndicatorTintColor = UIColor.lightGray
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFit
        
        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        slideshow.activityIndicator = DefaultActivityIndicator()
        slideshow.currentPageChanged = { page in
        }
        
        slideshow.setImageInputs(sourceImages)
        
        
    }
    
    func loadData() {
        
        self.startAnimating()
//                    self.showLoader()
        let param : [String : Any] = [:]
        RequestHandler.getHome(parameter: param as NSDictionary, success: { (successResponse) in
                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            self.defaults.set(dictionary["msgMarginAccountUsagePolicy"], forKey: "msgMarginAccountUsagePolicy")
            self.defaults.set(dictionary["msgCoinSwapFeePolicy"], forKey: "msgCoinSwapFeePolicy")
            self.defaults.set(dictionary["msgStockTradeFeePolicy"], forKey: "msgStockTradeFeePolicy")
            self.defaults.set(dictionary["msgCoinWithdrawFeePolicy"], forKey: "msgCoinWithdrawFeePolicy")
            self.defaults.set(dictionary["token_amount_for_stock_deposit_payment"], forKey: "token_amount_for_stock_deposit_payment")
            self.defaults.set(dictionary["stock_deposit_from_card_fee_percent"], forKey: "stock_deposit_from_card_fee_percent")
            self.defaults.set(dictionary["stock_deposit_from_card_daily_limit"], forKey: "stock_deposit_from_card_daily_limit")
            self.defaults.synchronize()
            
            var news : NewsModel!
            
            if let newsData = dictionary["news"] as? [[String:Any]] {
                self.newsList = [NewsModel]()
                for item in newsData {
                    news = NewsModel(fromDictionary: item)
                    self.newsList.append(news)
                }
                self.newsTable.reloadData()
            }
            
            var stocks : TopStocksModel!
            
            if let data = dictionary["top_stocks_gainers"] as? [[String:Any]] {
                self.topGainers = [TopStocksModel]()
                for item in data {
                    stocks = TopStocksModel(fromDictionary: item)
                    self.topGainers.append(stocks)
                }
                self.gainersTable.reloadData()
            }
            
            if let data = dictionary["top_stocks_losers"] as? [[String:Any]] {
                self.topLosers = [TopStocksModel]()
                for item in data {
                    stocks = TopStocksModel(fromDictionary: item)
                    self.topLosers.append(stocks)
                }
                self.losersTable.reloadData()
            }

            if let data = dictionary["banners"] as? [[String:Any]] {
                for item in data {
                    var path = item["image"] as? String
                    if path?.starts(with: "http") == false {
                        path = Constants.URL.base + "storage/" + path!
                    }
                    self.localImages.append(path!)
                }
                self.imageSliderSetting()
            }
                    
                
            }) { (error) in
                        self.stopAnimating()
                let alert = Alert.showBasicAlert(message: error.message)
                        self.presentVC(alert)
            }
        
    }
    
    
}

extension HomeController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case newsTable:
            tableView.estimatedRowHeight = 300
            return newsList.count
        case gainersTable:
//            tableView.estimatedRowHeight = 35
            return topGainers.count
        case losersTable:
//            tableView.estimatedRowHeight = 35
            return topLosers.count
        default:
            print("default")
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
        case newsTable:
            return 310
        case gainersTable:
            return 45
        case losersTable:
            return 45
        default:
            print("default")
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
            case gainersTable:
                let item = topGainers[indexPath.row]
                let detailController = storyboard?.instantiateViewController(withIdentifier: "StocksDetailController") as! StocksDetailController
                detailController.topStocks = item
                
                self.navigationController?.pushViewController(detailController, animated: true)
            case losersTable:
                let item = topLosers[indexPath.row]
                let detailController = storyboard?.instantiateViewController(withIdentifier: "StocksDetailController") as! StocksDetailController
                detailController.topStocks = item
                
                self.navigationController?.pushViewController(detailController, animated: true)
                
        default:
            print("No data")
        }
        

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView {
        case newsTable:
            let cell: NewsView = tableView.dequeueReusableCell(withIdentifier: "NewsView", for: indexPath) as! NewsView
            
            let news = newsList[indexPath.row]
            cell.title.text = news.title
            cell.summary.text = news.description
            cell.date.text = news.date
            if let image = news.image{
                cell.logo.load(url: URL(string:image)!)
            }
            return cell
        case gainersTable:
            let cell: TopStocksItem = tableView.dequeueReusableCell(withIdentifier: "TopStocksItem", for: indexPath) as! TopStocksItem
            
            let item = topGainers[indexPath.row]
            cell.lbName.text = item.name
            cell.lbSymbol.text = item.symbol
            cell.lbPrice.text = PriceFormat(amount: item.price, currency: .usd).description
            cell.lbChange.text = "\(item.change!)\(item.changePercent!)"
            if item.change.starts(with: "-") {
                cell.lbChange.textColor = .systemRed
            } else {
                cell.lbChange.textColor = .systemGreen
            }
            return cell
        case losersTable:
            let cell: TopStocksItem = tableView.dequeueReusableCell(withIdentifier: "TopStocksItem", for: indexPath) as! TopStocksItem
            
            let item = topLosers[indexPath.row]
            cell.lbName.text = item.name
            cell.lbSymbol.text = item.symbol
            cell.lbPrice.text = PriceFormat(amount: item.price, currency: .usd).description
            cell.lbChange.text = "\(item.change!)\(item.changePercent!)"
            if item.change.starts(with: "-") {
                cell.lbChange.textColor = .systemRed
            } else {
                cell.lbChange.textColor = .systemGreen
            }
            return cell
        default:
            print("default")
            let cell = UITableViewCell()
            return cell
        }
        
    }
}
