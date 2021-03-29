//
//  TradeTokenController.swift
//  wyretrade
//
//  Created by maxus on 3/8/21.
//

import Foundation
import UIKit
import AnyChartiOS
import DropDown
import XLPagerTabStrip

class TradeTokenController: UIViewController, IndicatorInfoProvider {
    
    var itemInfo: IndicatorInfo = "Token"
    let scrollViewContentHeight = 1200 as CGFloat
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tradingView: UIView!
    @IBOutlet weak var chartView: UIView!
    
    @IBOutlet weak var spinnerView: UIView!
    @IBOutlet weak var btnPair: UIButton!
    
    @IBOutlet weak var chartTab: UISegmentedControl!
    
    
    @IBOutlet weak var lbXMTBalance: UILabel!
    @IBOutlet weak var lbBtcBalance: UILabel!
    
    @IBOutlet weak var lbHighRate: UILabel!
    @IBOutlet weak var lbLowRate: UILabel!
    
    @IBOutlet weak var lbVolAmount: UILabel!
    @IBOutlet weak var lbAskAmount: UILabel!
    @IBOutlet weak var lbBidAmount: UILabel!
    
    @IBOutlet weak var lbThQty: UILabel!
    @IBOutlet weak var lbThAmount: UILabel!
    
    @IBOutlet weak var orderTable: UITableView! {
        didSet {
            orderTable.delegate = self
            orderTable.dataSource = self
            orderTable.showsVerticalScrollIndicator = false
            orderTable.separatorColor = UIColor.darkGray
            orderTable.separatorStyle = .singleLineEtched
            orderTable.register(UINib(nibName: "TokenOrderItem", bundle: nil), forCellReuseIdentifier: "TokenOrderItem")
            
        }
    }
    
    @IBOutlet weak var askTable: UITableView! {
        didSet {
            askTable.delegate = self
            askTable.dataSource = self
            askTable.showsVerticalScrollIndicator = false
            askTable.separatorColor = UIColor.darkGray
            askTable.separatorStyle = .singleLineEtched
            
            askTable.register(UINib(nibName: "TokenAskItem", bundle: nil), forCellReuseIdentifier: "TokenAskItem")
        }
    }
    
    @IBOutlet weak var bidTable: UITableView! {
        didSet {
            bidTable.delegate = self
            bidTable.dataSource = self
            bidTable.showsVerticalScrollIndicator = false
            bidTable.separatorColor = UIColor.darkGray
            bidTable.separatorStyle = .singleLineEtched
            
            bidTable.register(UINib(nibName: "TokenBidItem", bundle: nil), forCellReuseIdentifier: "TokenBidItem")
        }
    }
    
    
    @IBOutlet weak var lbHighQty: UILabel!
    @IBOutlet weak var lbHighAmount: UILabel!
    
    var orderList = [TokenOrderModel]()
    var askList = [Ask]()
    var bidList = [Ask]()
    
    var askAggregates = [TokenOrderModel]()
    var bidAggregates = [TokenOrderModel]()
    var askAggregatesDay = [TokenOrderModel]()
    var bidAggregatesDay = [TokenOrderModel]()
    var askAggregatesWeek = [TokenOrderModel]()
    var bidAggregatesWeek = [TokenOrderModel]()
    var askAggregatesMonth = [TokenOrderModel]()
    var bidAggregatesMonth = [TokenOrderModel]()
    var askAggregatesAll = [TokenOrderModel]()
    var bidAggregatesAll = [TokenOrderModel]()
    
    let dropdown = DropDown()
    
    var chartData: Array<DataEntry> = []
    var set: anychart.data.Set!
    
    
    var selectedPair = "XMT-BTC"
    var pairs = [TokenTradePair]()
    
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //        self.addLeftBarButtonWithImage(UIImage(named: "ic_menu")!)
        self.addTradeView()
        
        scrollView.contentSize.height = scrollViewContentHeight
        scrollView.autoresizingMask = UIView.AutoresizingMask.flexibleHeight
        scrollView.delegate = self
        
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(TradeTokenController.update), userInfo: nil, repeats: true)
        
//        self.updateChartData()
        initTradeChart()
//        dropdown.anchorView = view//self.spinnerView
        dropdown.selectionAction = {  (index: Int, item: String) in print(index)}
        
        self.loadData()
        self.loadPairs()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       super.viewWillDisappear(animated)
        timer?.invalidate()
       dismiss(animated: true, completion: nil)
        
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    @objc func update() {
        
        self.loadData()
    }
    
    func initTradeChart() {
        
        
        let anyChartView = AnyChartView()
        self.chartView.addSubview(anyChartView)
        
        anyChartView.translatesAutoresizingMaskIntoConstraints = false
        anyChartView.centerXAnchor.constraint(equalTo: self.chartView.centerXAnchor).isActive = true
        anyChartView.centerYAnchor.constraint(equalTo: self.chartView.centerYAnchor).isActive = true
        anyChartView.widthAnchor.constraint(equalTo: self.chartView.widthAnchor).isActive = true
        anyChartView.heightAnchor.constraint(equalTo: self.chartView.heightAnchor).isActive = true
        
        let chart = AnyChart.area()
        chart.animation(settings: true)
        chart.xAxis(settings: false)
        chart.yAxis(settings: false)
        chart.yGrid(settings: true)
        chart.yGrid(index: 3.0)
        chart.yScale().stackMode(value: anychart.enums.ScaleStackMode.VALUE)
        
        set = anychart.data.Set().instantiate()
        set.data(data: self.chartData)
        
       var series1Mapping = set.mapAs(mapping: "{x: 'x', value: 'value'}")
        var series2Mapping = set.mapAs(mapping: "{x: 'x', value: 'value2'}")
        
        let series1 = chart.area(data: series1Mapping)
        series1.name(name: "Ask")
        series1.stroke(settings: "1 #ee204d");
        series1.color(color: "#ee204d");
        let series2 = chart.area(data: series2Mapping)
        series2.name(name: "Bid")
        series1.stroke(settings: "1 #3AE57F");
        series1.color(color: "#3AE57F");
        
        anyChartView.setChart(chart: chart)
        
    }
    
    func updateChartData() {
        
        for (index, item) in self.askAggregates.enumerated() {
            
            self.chartData.append(CustomDataEntry(x: "Q\(index)", value: item.price))
        }
        
        for (index, item) in self.bidAggregates.enumerated() {
            self.chartData.append(CustomDataEntry2(x: "Q\(index)", value: item.price))
        }
        
        set.data(data: self.chartData)
        
    }

    
    func addTradeView() {
        let tradeVC = storyboard!.instantiateViewController(withIdentifier: "TradeTokenPagerVC")
        addChild(tradeVC)
        tradingView.addSubview(tradeVC.view)
        tradeVC.view.frame = CGRect(x: 0, y: 0, width: 150, height: 310)
        tradeVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        tradeVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        tradeVC.didMove(toParent: self)
    }
    
    func loadData() {
        let param : [String : Any] = ["pair": self.selectedPair]
        self.btnPair.setTitle(self.selectedPair, for: .normal)
                RequestHandler.xmtTradeData(parameter: param as NSDictionary, success: { (successResponse) in
        //                        self.stopAnimating()
                    let dictionary = successResponse as! [String: Any]
                   let data = TokenTradeDataModel(fromDictionary: dictionary)
                    self.orderList = data.orders
                    self.askList = data.asks
                    self.bidList = data.bids
                    
                    self.orderTable.reloadData()
                    self.askTable.reloadData()
                    self.bidTable.reloadData()
                    self.lbThQty.text = "Qty(\(data.coin2!))"
                    self.lbLowRate.text = data.lastLow + data.coin2
                    self.lbHighRate.text = data.lastHigh + data.coin2
                    self.lbHighQty.text = data.maxBid.qty
                    self.lbHighAmount.text = data.maxBid.price
                    self.lbVolAmount.text = data.changeVol
                    self.lbAskAmount.text = data.asksTotal
                    self.lbBidAmount.text = data.bidsTotal
                    self.lbXMTBalance.text = "\(data.coin2Balance!) \(data.coin2!)"
                    self.lbBtcBalance.text = "\(data.coin1Balance!) \(data.coin1!)"
                    
                    self.askAggregates = data.askAggregates
                    self.bidAggregates = data.bidAggregates
                    
                    self.updateChartData()
                    
                    
                    
                    NotificationCenter.default.post(name: .didUpdateBalance, object: data)
                    }) { (error) in
                        let alert = Alert.showBasicAlert(message: error.message)
                                self.presentVC(alert)
                    }
    }
    
    func loadPairs() {
        let param : [String : Any] = [:]
                RequestHandler.xmtTradeList(parameter: param as NSDictionary, success: { (successResponse) in
        //                        self.stopAnimating()
                    let dictionary = successResponse as! [[String: Any]]
                   
                    var pair : TokenTradePair!
                                
                    
                        self.pairs = [TokenTradePair]()
                        for item in dictionary {
                            pair = TokenTradePair(fromDictionary: item)
                            self.pairs.append(pair)
//                            self.dropdown.dataSource.append("\(pair.symbol!)")
                        }
                        
                    
                    
                    }) { (error) in
                        let alert = Alert.showBasicAlert(message: error.message)
                                self.presentVC(alert)
                    }
    }
    
    @IBAction func actionViewHistory(_ sender: Any) {
        let detailController = storyboard?.instantiateViewController(withIdentifier: "TradeTokenHistoryController") as! TradeTokenHistoryController
        detailController.pair = self.selectedPair
        self.navigationController?.pushViewController(detailController, animated: true)
    }
  
    @IBAction func indexChanged(_ sender: Any) {
        switch chartTab.selectedSegmentIndex {
        case 0:
            self.updateChartData()
            
        default:
            break
        }
        
//        self.updateChartData()
    }
    
    @IBAction func actionPair(_ sender: Any) {
        let alertController = UIAlertController(title: "Select pair", message: "", preferredStyle: .alert)
        for item in self.pairs {
            
            let action = UIAlertAction(title: item.symbol, style: .default) { (_) in
                self.selectedPair = item.symbol!
                self.loadData()
            }
            alertController.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        self.presentVC(alertController);
    }
    
    
}

extension TradeTokenController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case orderTable:
            
            return orderList.count
        case askTable:
            
            return askList.count
        case bidTable:
            
            return bidList.count
        default:
            print("default")
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView {
        case orderTable:
            let cell: TokenOrderItem = tableView.dequeueReusableCell(withIdentifier: "TokenOrderItem", for: indexPath) as! TokenOrderItem
            let item = orderList[indexPath.row]
            cell.lbPair.text = item.pair
            cell.lbQty.text = item.qty
            cell.lbPrice.text = "\(item.price!)"
            cell.lbType.text = item.type
            return cell
        case askTable:
            let cell: TokenAskItem = tableView.dequeueReusableCell(withIdentifier: "TokenAskItem", for: indexPath) as! TokenAskItem
            let item = askList[indexPath.row]
            
            cell.lbQty.text = item.qty
            cell.lbPrice.text = item.price
            return cell
        case bidTable:
            let cell: TokenBidItem = tableView.dequeueReusableCell(withIdentifier: "TokenBidItem", for: indexPath) as! TokenBidItem
            let item = bidList[indexPath.row]
            
            cell.lbQty.text = item.qty
            cell.lbPrice.text = item.price
            return cell
        default:
            print("No cell")
            let cell = UITableViewCell()
            return cell
        }
        

        
    }
}

class CustomDataEntry: ValueDataEntry {
    init(x: String, value: Double) {
        super.init(x: x, value: value)
        
    }
}

class CustomDataEntry2: ValueDataEntry {
    init(x: String, value: Double) {
        super.init(x: x, value: value)
        setValue(key: "value2", value: value)
        
    }
}
