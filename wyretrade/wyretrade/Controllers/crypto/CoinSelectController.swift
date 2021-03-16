//
//  CoinSelectController.swift
//  wyretrade
//
//  Created by brian on 3/16/21.
//

import Foundation
import UIKit

class CoinSelectController: UIViewController {
    
    @IBOutlet weak var coinTable: UITableView! {
        didSet {
            coinTable.delegate = self
            coinTable.dataSource = self
            coinTable.showsVerticalScrollIndicator = false
            coinTable.separatorColor = UIColor.darkGray
            coinTable.separatorStyle = .singleLineEtched
            coinTable.register(UINib(nibName: "CoinSelectItem", bundle: nil), forCellReuseIdentifier: "CoinSelectItem")
        }
    }
    
    var coinList = [CoinModel]()
    
    var delegate: CoinSelectontrollerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       self.navigationController?.isNavigationBarHidden = true
       
   }

   override func viewWillDisappear(_ animated: Bool) {
       super.viewWillDisappear(animated)
       self.navigationController?.isNavigationBarHidden = false
   }
    
    func loadData() {
            let param : [String : Any] = [:]
            RequestHandler.getCoinWithdrawableAssets(parameter: param as NSDictionary, success: { (successResponse) in
    //                        self.stopAnimating()
                let dictionary = successResponse as! [String: Any]
                
                var coin : CoinModel!
                
                if let Data = dictionary["assets"] as? [[String:Any]] {
                    self.coinList = [CoinModel]()
                    for item in Data {
                        coin = CoinModel(fromDictionary: item)
                        self.coinList.append(coin)
                    }
                    self.coinTable.reloadData()
                }
                
                }) { (error) in
                    let alert = Alert.showBasicAlert(message: error.message)
                            self.presentVC(alert)
                }
        }
}

extension CoinSelectController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coinList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        
        let item = coinList[indexPath.row]
        
        self.delegate.selectCoin(param: item)
        self.navigationController?.popViewController(animated: true)

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CoinSelectItem = tableView.dequeueReusableCell(withIdentifier: "CoinSelectItem", for: indexPath) as! CoinSelectItem
        let item = coinList[indexPath.row]
        cell.imgIcon.load(url: URL(string: item.icon)!)
        cell.lbName.text = item.name
        

        return cell
    }
}

protocol CoinSelectontrollerDelegate {
    func selectCoin(param: CoinModel)
}
