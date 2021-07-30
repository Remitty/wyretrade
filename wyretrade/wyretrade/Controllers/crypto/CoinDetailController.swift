//
//  StocksDetailController.swift
//  wyretrade
//
//  Created by maxus on 3/4/21.
//

import Foundation
import UIKit
import AnyChartiOS
import NVActivityIndicatorView

class CoinDetailController: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet weak var lbSymbol: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbChange: UILabel!
    @IBOutlet weak var lbBalance: UILabel!
    
    @IBOutlet weak var lbOpen: UILabel!
    @IBOutlet weak var lbLast: UILabel!
    @IBOutlet weak var lbHigh: UILabel!
    @IBOutlet weak var lbLow: UILabel!
    @IBOutlet weak var lbBid: UILabel!
    @IBOutlet weak var lbAsk: UILabel!
    
    @IBOutlet weak var viewChart: UIView!
    @IBOutlet weak var chartTab: UISegmentedControl!
    
    @IBOutlet weak var btnDeposit: UIButton! {
        didSet {
            btnDeposit.roundCornors()
        }
    }
    @IBOutlet weak var btnWithdraw: UIButton! {
        didSet {
            btnWithdraw.roundCornors()
        }
    }
    
    @IBOutlet weak var btnTrade: UIButton! {
        didSet {
            btnTrade.roundCornors()
        }
    }
    
    var coin: CoinModel!
    
    var stocksBalance = 0.0

    var chartData: Array<DataEntry> = []
    
    var chartDayData = [OHLCModel]()
    var chartWeekData = [OHLCModel]()
    var chartMonthData = [OHLCModel]()
//    var chartMonth6Data = [OHLCModel]()
    var chartYearData = [OHLCModel]()
    var chartAllData = [OHLCModel]()
    var chartTempData = [OHLCModel]()
    
    var series1Mapping: anychart.data.View!
    var set: anychart.data.Set!
    
    var coinList = [CoinModel]()
    var onramperApiKey: String!
    var xanpoolApiKey: String!
    var onRamperCoins = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if self.coin != nil {
            self.lbSymbol.text = self.coin.symbol
            self.lbName.text = self.coin.name
            self.lbPrice.text = self.coin.price
            self.lbBalance.text = self.coin.balance
            
            if self.coin.changeToday >= 0 {
                self.lbChange.textColor = UIColor.green
                self.lbChange.text = "+\(self.coin.changeToday!)% Today"
            } else {
                self.lbChange.textColor = UIColor.red
                self.lbChange.text = "\(self.coin.changeToday!)% Today"
            }
            
            
        }
        
        initTradeChart()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadData()
    }
    
   
    
    func loadData() {
        self.startAnimating()
        let param : [String : Any] = ["asset": self.coin.symbol!]
        RequestHandler.getCoinDetail(parameter: param as NSDictionary, success: { (successResponse) in
                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            let data = dictionary["data"] as! [String: Any]
            if let temp = data["quote"] as? [String: Any] {
                let quote = CoinQuoteModel(fromDictionary: temp)
                self.lbLow.text = quote?.low
                self.lbHigh.text = quote?.high
                self.lbOpen.text = quote?.open
                self.lbLast.text = quote?.last
                self.lbAsk.text = quote?.ask
                self.lbBid.text = quote?.bid
                self.lbPrice.text = quote?.last
            }
            

            var chart : OHLCModel!
            
            if let today_candel = data["today_candel"] as? [[Any]] {
                
                for item in today_candel {
                    chart = OHLCModel(fromDictionary: item)
                    
                    self.chartDayData.append(chart)
                }
                
            }
            
            if let week_candel = data["week_candel"] as? [[Any]] {

                for item in week_candel {
                    chart = OHLCModel(fromDictionary: item)
                    self.chartWeekData.append(chart)
                }

            }

            if let month_candel = data["month_candel"] as? [[Any]] {

                for item in month_candel {
                    chart = OHLCModel(fromDictionary: item)
                    self.chartMonthData.append(chart)
                }

            }

            if let year_candel = data["year_candel"] as? [[Any]] {

                for item in year_candel {
                    chart = OHLCModel(fromDictionary: item)
                    self.chartYearData.append(chart)
                }

            }

            if let all_candel = data["all_candel"] as? [[Any]] {
                
                print(all_candel)
                for item in all_candel {
                    chart = OHLCModel(fromDictionary: item)
                    self.chartAllData.append(chart)
                }

            }
            
            self.chartTempData = self.chartDayData
            self.updateChartData()
//            self.initTradeChart()
            
            
        }) { (error) in
                        self.stopAnimating()
            let alert = Alert.showBasicAlert(message: error.message)
                    self.presentVC(alert)
        }
    }
    
    func initTradeChart() {
        
        
        let anyChartView = AnyChartView()
        self.viewChart.addSubview(anyChartView)
        
        anyChartView.translatesAutoresizingMaskIntoConstraints = false
        anyChartView.centerXAnchor.constraint(equalTo: self.viewChart.centerXAnchor).isActive = true
        anyChartView.centerYAnchor.constraint(equalTo: self.viewChart.centerYAnchor).isActive = true
        anyChartView.widthAnchor.constraint(equalTo: self.viewChart.widthAnchor).isActive = true
        anyChartView.heightAnchor.constraint(equalTo: self.viewChart.heightAnchor).isActive = true
        
        let chart = AnyChart.line()
        chart.animation(settings: true)
        chart.xAxis(settings: false)
        chart.yAxis(settings: true)
        chart.yGrid(settings: true)
        chart.yGrid(index: 3.0)
        
        set = anychart.data.Set().instantiate()
        
        
        series1Mapping = set.mapAs(mapping: "{x: 'x', value: 'value'}")
        
        
        let series1 = chart.line(data: series1Mapping)
//        series1.name(name: "Ask")
//        series1.stroke(settings: "0 #ee204d");
//        series1.color(color: "#ee204d");
        
        
        anyChartView.setChart(chart: chart)
        
    }
    
    func updateChartData() {
        self.chartData.removeAll()
        for item in self.chartTempData{
            
            self.chartData.append(CustomDataEntry(x: item.date, value: item.close))

        }
        
        set.data(data: self.chartData)
    }

    @IBAction func actionDeposit(_ sender: Any) {
        
        let parameter: NSDictionary = [
            "coin": coin.id!,
            "symbol": coin.symbol!
        ]
        
        self.startAnimating()
        RequestHandler.coinDeposit(parameter: parameter, success: {(successResponse) in
            self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            let address = dictionary["address"] as! String
           
            let alertController = UIAlertController(title: "Send only \(self.coin.symbol!) to this address", message: nil, preferredStyle: .alert)
            let copyAction = UIAlertAction(title: "Copy", style: .default) { (_) in
                let pasteboard = UIPasteboard.general
                pasteboard.string = address
                self.showToast(message: "Copied successfully")
            }
            
            alertController.addTextField { (textField) in
                textField.text = address
            }
            alertController.addAction(copyAction)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))

            
            self.present(alertController, animated: true, completion: nil)
            
            
        }) {
            (error) in
                        self.stopAnimating()
            let alert = Alert.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
        
    }
    
    @IBAction func actionWithdrw(_ sender: Any) {
        let buyController = storyboard?.instantiateViewController(withIdentifier: "CoinWithdrawController") as! CoinWithdrawController
        
        self.navigationController?.pushViewController(buyController, animated: true)
    }
    
    
    @IBAction func actionTrade(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CoinTradePagerVC") as! CoinTradePagerVC
        vc.coinList = self.coinList
        vc.onRamperCoins = self.onRamperCoins
        vc.onramperApiKey = self.onramperApiKey
        vc.xanpoolApiKey = self.xanpoolApiKey
        vc.currentIdx = 1
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func indexChanged(_ sender: Any) {
        switch chartTab.selectedSegmentIndex {
        case 0:
            chartTempData = chartDayData
        case 1:
            chartTempData = chartWeekData
        case 2:
            chartTempData = chartMonthData
        
        case 3:
            chartTempData = chartYearData
        case 4:
            chartTempData = chartAllData
        default:
            break
        }
        
        updateChartData()
    }
}
