//
//  CoinTradeController.swift
//  wyretrade
//
//  Created by brian on 3/27/21.
//

import Foundation
import UIKit
import MaterialComponents.MDCCard
import SafariServices
import XLPagerTabStrip
import NVActivityIndicatorView

class CoinTradeController: UIViewController, IndicatorInfoProvider, NVActivityIndicatorViewable {
    
    var itemInfo: IndicatorInfo = "Fiat payment"
    
    @IBOutlet weak var viewXanpool: MDCCard!
    @IBOutlet weak var viewRamp: MDCCard!
    @IBOutlet weak var viewOnramp: MDCCard!
    
    var kind = 0
    var symbol = ""
    var address = ""
    
    var coinList = [CoinModel]()
    var assetList = [CoinModel]()
    var onramperApiKey: String!
    var xanpoolApiKey: String!
    var onRamperCoins = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewXanpool.isUserInteractionEnabled = true
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(CoinTradeController.xanpoolClick))
        viewXanpool.addGestureRecognizer(tap1)
        
        viewRamp.isUserInteractionEnabled = true
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(CoinTradeController.rampClick))
        viewRamp.addGestureRecognizer(tap2)
        
        viewOnramp.isUserInteractionEnabled = true
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(CoinTradeController.onrampClick))
        viewOnramp.addGestureRecognizer(tap3)
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    @objc func xanpoolClick(sender: UITapGestureRecognizer) {
        kind = 0
        assetList = [CoinModel]()
        for item in coinList {
            if item.buyType > 1 && item.buyType < 100 {
                assetList.append(item)
            }
        }
        
        let detailController = self.storyboard?.instantiateViewController(withIdentifier: "CoinSelectController") as! CoinSelectController
        detailController.delegate = self
        detailController.coinList = self.assetList
        self.navigationController?.pushViewController(detailController, animated: true)
    }
    
    @objc func rampClick(sender: UITapGestureRecognizer) {
        kind = 1
        assetList = [CoinModel]()
        for item in coinList {
            if item.buyType > 0 && item.buyType < 100 {
                assetList.append(item)
            }
            
        }
        
        let detailController = self.storyboard?.instantiateViewController(withIdentifier: "CoinSelectController") as! CoinSelectController
        detailController.delegate = self
        detailController.coinList = self.assetList
        self.navigationController?.pushViewController(detailController, animated: true)
    }
    
    @objc func onrampClick(sender: UITapGestureRecognizer) {
        kind = 2
        assetList = [CoinModel]()
        for item in coinList {
            if item.buyType > 2 && item.buyType < 100 {
                assetList.append(item)
            }
        }
        
        let detailController = self.storyboard?.instantiateViewController(withIdentifier: "CoinSelectController") as! CoinSelectController
        detailController.delegate = self
        detailController.coinList = self.assetList
        self.navigationController?.pushViewController(detailController, animated: true)
    }
    
    
    func doXanpool() {
        
        
        let base = "https://checkout.xanpool.com/"
        let apiKey = "?apiKey=\(self.xanpoolApiKey!)"
        let wallet = "&wallet=\(self.address)"
        let symbol = "&cryptoCurrency=\(self.symbol)"
        let autoSelling = "&autoSelling=true"
//        let transactionType = "&transactionType="
        let isWebview = "&isWebview=true"
        let partner = "&partnerData=88824d8683434f4e"
         let url = base + apiKey + wallet + symbol + autoSelling + isWebview + partner
        
        let webviewController = self.storyboard?.instantiateViewController(withIdentifier: "webVC") as! webVC
        webviewController.url = url
        self.navigationController?.pushViewController(webviewController, animated: true)
    }
    
    func doRamp() {
        
        var configuration = Ramp.Configuration(url: "https://widget-instant.ramp.network/")
        configuration.userAddress = self.address
        configuration.swapAsset = self.symbol
//            configuration.fiatValue = "2"
//            configuration.swapAsset = "BTC"
        configuration.webhookStatusUrl = "https://joiintapp.com/api/coinstock/ramp/webhook"
        let rampWidgetUrl = configuration.composeUrl()
        
        let rampVC = SFSafariViewController(url: rampWidgetUrl)
        rampVC.modalPresentationStyle = .overFullScreen
        self.present(rampVC, animated: true)
    }
    
    func doOnramp() {
        let excludeCryptos = "&excludeCryptos=EOS,USDT,XLM,BUSD,GUSD,HUSD,PAX,USDS"
        let coin_address = "&wallets=" + self.symbol + ":" + self.address
        let url = "https://widget.onramper.com?color=1d2d50&apiKey=\(self.onramperApiKey!)&defaultCrypto=\(symbol)\(excludeCryptos)\(coin_address)&onlyCryptos=\(self.onRamperCoins)&isAddressEditable=false"
        
        let webviewController = self.storyboard?.instantiateViewController(withIdentifier: "webVC") as! webVC
        webviewController.url = url
        self.navigationController?.pushViewController(webviewController, animated: true)
    }
    
}

extension CoinTradeController: CoinSelectControllerDelegate {
    func selectCoin(param: CoinModel) {
        let param1: NSDictionary = [
            "coin": param.id!,
            "symbol": param.symbol!
        ]
        self.startAnimating()
        RequestHandler.coinDeposit(parameter: param1, success: {(successResponse) in
            self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            self.address = dictionary["address"] as! String
            self.symbol = param.symbol
            
            switch self.kind {
            case 0:
                self.doXanpool()
            case 1:
                self.doRamp()
            case 2:
                self.doOnramp()
            default:
                print("No data")
            }
            
        
        }) {
            (error) in
                        self.stopAnimating()
            let alert = Alert.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
}
