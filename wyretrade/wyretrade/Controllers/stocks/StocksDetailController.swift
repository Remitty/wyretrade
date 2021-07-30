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

class StocksDetailController: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet weak var lbStocksSymbol: UILabel!
    @IBOutlet weak var lbStocksName: UILabel!
    @IBOutlet weak var lbStocksPrice: UILabel!
    @IBOutlet weak var lbStocksChange: UILabel!
    @IBOutlet weak var lbShares: UILabel!
    @IBOutlet weak var lbAvgPrice: UILabel!
    @IBOutlet weak var lbHolding: UILabel!
    @IBOutlet weak var lbProfit: UILabel!
    @IBOutlet weak var imgProfit: UIImageView!
    
    @IBOutlet weak var viewChart: UIView!
    @IBOutlet weak var chartTab: UISegmentedControl!
    @IBOutlet weak var viewCompany: UIView!
    @IBOutlet weak var viewFirst: UIView!
    @IBOutlet weak var viewSecond: UIView!
    
    
    @IBOutlet weak var lbYearHigh: UILabel!
    @IBOutlet weak var lbYearLow: UILabel!
    @IBOutlet weak var lbVolume: UILabel!
    
    @IBOutlet weak var lbCompanyIndustry: UILabel!
    @IBOutlet weak var lbCompanydDes: UILabel!
    @IBOutlet weak var lbCompanyCeo: UILabel!
    @IBOutlet weak var tvCompanyUrl: UITextView!
    
    @IBOutlet weak var btnBuy: UIButton! {
        didSet {
            btnBuy.roundCorners()
        }
    }

    @IBOutlet weak var btnSell: UIButton! {
        didSet {
            btnSell.roundCorners()
        }
    }
    
    var stocks: StockPositionModel!
    var topStocks: TopStocksModel!
    var stocksBalance = 0.0

    var company: CompanyModel!
    let companyView = Company().loadView() as! Company
    var chartData: Array<DataEntry> = []
    
    var chartDayData = [ChartModel]()
    var chartWeekData = [ChartModel]()
    var chartMonthData = [ChartModel]()
    var chartMonth6Data = [ChartModel]()
    var chartYearData = [ChartModel]()
    var chartAllData = [ChartModel]()
    var chartTempData = [ChartModel]()
    
    var series1Mapping: anychart.data.View!
    var set: anychart.data.Set!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if self.stocks != nil {
            self.lbStocksSymbol.text = self.stocks.ticker
            self.lbStocksName.text = self.stocks.name
            self.lbStocksPrice.text = self.stocks.price
            self.lbStocksChange.text = "$\(self.stocks.changeToday!) (\(self.stocks.changeTodayPercent!)%)  Today"
            
            if self.stocks.dbProfit >= 0 {
                self.lbProfit.textColor = UIColor.green
                self.lbStocksChange.textColor = UIColor.green
                self.imgProfit.image = UIImage(named: "ic_up")
            } else {
                self.lbProfit.textColor = UIColor.red
                self.lbStocksChange.textColor = UIColor.red
                self.imgProfit.image = UIImage(named: "ic_down")
            }
            
            if self.stocks.shares > 0 {
                self.lbShares.text = "\(self.stocks.shares!)"
                self.lbAvgPrice.text = self.stocks.avgPrice
                self.lbHolding.text = self.stocks.holding
                self.lbProfit.text = self.stocks.profit
            } else {
                self.viewFirst.isHidden = true
                self.viewSecond.isHidden = true
                self.btnSell.isHidden = true
            }
        }
        
        if self.topStocks != nil {
            self.lbStocksSymbol.text = self.topStocks.symbol
            self.lbStocksName.text = self.topStocks.name
            self.lbStocksPrice.text = "\(self.topStocks.price!)"
            self.lbStocksChange.text = "\(self.topStocks.change!)\(self.topStocks.changePercent!)  Today"
            
            self.viewFirst.isHidden = true
            self.viewSecond.isHidden = true
            self.btnSell.isHidden = true
        }
//
//        self.loadData()
        
//        self.configCompany()
        
        initTradeChart()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadData()
    }
    
    private func configCompany() {
        self.companyView.translatesAutoresizingMaskIntoConstraints = false
        self.viewCompany.addSubview(self.companyView)
    }
    
    func loadData() {
        self.startAnimating()
        let param : [String : Any] = ["ticker": self.lbStocksSymbol.text!]
        RequestHandler.getStockDetail(parameter: param as NSDictionary, success: { (successResponse) in
                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            self.stocksBalance = dictionary["stock_balance"] as! Double
            
            self.stocks = StockPositionModel(fromDictionary: dictionary["stock"] as! [String: Any])
            self.lbYearLow.text = self.stocks.yearLow
            self.lbYearHigh.text = self.stocks.yearHigh
            self.lbVolume.text = self.stocks.lastVolume

            var chart : ChartModel!
            
            if let data = dictionary["aggregate_day"] as? [[String:Any]] {
                
                for item in data {
                    chart = ChartModel(fromDictionary: item)
                    self.chartDayData.append(chart)
                }
                
            }
            
            if let data = dictionary["aggregate_week"] as? [[String:Any]] {
                
                for item in data {
                    chart = ChartModel(fromDictionary: item)
                    self.chartWeekData.append(chart)
                }
                
            }
            
            if let data = dictionary["aggregate_month"] as? [[String:Any]] {
                
                for item in data {
                    chart = ChartModel(fromDictionary: item)
                    self.chartMonthData.append(chart)
                }
                
            }
            
            if let data = dictionary["aggregate_month6"] as? [[String:Any]] {
                
                for item in data {
                    chart = ChartModel(fromDictionary: item)
                    self.chartMonth6Data.append(chart)
                }
                
            }
            
            if let data = dictionary["aggregate_year"] as? [[String:Any]] {
                
                for item in data {
                    chart = ChartModel(fromDictionary: item)
                    self.chartYearData.append(chart)
                }
                
            }
            
            if let data = dictionary["aggregate_all"] as? [[String:Any]] {
                
                for item in data {
                    chart = ChartModel(fromDictionary: item)
                    self.chartAllData.append(chart)
                }
                
            }
            
            self.chartTempData = self.chartDayData
            self.updateChartData()
//            self.initTradeChart()
            
            guard let company = dictionary["company"] else {
                return
            }
            
            self.company = CompanyModel(fromDictionary: company as! [String: Any])
            self.lbCompanydDes.text = self.company.description
            self.lbCompanyIndustry.text = self.company.industry
            self.lbCompanyCeo.text = "CEO: "+self.company.ceo
            let attributedString = NSMutableAttributedString(string: "View site")
            attributedString.addAttribute(.link, value: self.company.site!, range: NSRange(location: 0, length: 9))
            self.tvCompanyUrl.attributedText = attributedString
//            self.companyView.lbDate.text = self.company.site
            
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
        chart.yAxis(settings: false)
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
        for item in self.chartTempData.reversed() {
            
            self.chartData.append(CustomDataEntry(x: item.date, value: item.value))

        }
        
        set.data(data: self.chartData)
    }

    @IBAction func actionBuy(_ sender: Any) {
        let buyController = storyboard?.instantiateViewController(withIdentifier: "StocksBuyController") as! StocksBuyController
        buyController.stocks = self.stocks
        buyController.company = self.company
        buyController.stocksBalance = self.stocksBalance
        buyController.side = "buy"
        self.navigationController?.pushViewController(buyController, animated: true)
    }
    
    @IBAction func actionSell(_ sender: Any) {
        let buyController = storyboard?.instantiateViewController(withIdentifier: "StocksBuyController") as! StocksBuyController
        buyController.stocks = self.stocks
        buyController.company = self.company
        buyController.stocksBalance = self.stocksBalance
        buyController.side = "sell"
        self.navigationController?.pushViewController(buyController, animated: true)
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
            chartTempData = chartMonth6Data
        case 4:
            chartTempData = chartYearData
        case 5:
            chartTempData = chartAllData
        default:
            break
        }
        
        updateChartData()
    }
}
