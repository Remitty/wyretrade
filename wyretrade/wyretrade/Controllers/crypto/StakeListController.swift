//
//  StakeListController.swift
//  wyretrade
//
//  Created by maxus on 3/3/21.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class StakeListController: UIViewController, NVActivityIndicatorViewable {

    @IBOutlet weak var stakeCoinTable: UITableView! {
        didSet {
            stakeCoinTable.delegate = self
            stakeCoinTable.dataSource = self
            stakeCoinTable.showsVerticalScrollIndicator = false
            stakeCoinTable.separatorColor = UIColor.darkGray
            stakeCoinTable.separatorStyle = .singleLineEtched
            stakeCoinTable.register(UINib(nibName: "StakeCoin", bundle: nil), forCellReuseIdentifier: "StakeCoin")
        }
    }
    
    var coinList = [StakeCoinModel]()
    var baseStellar: StellarAccount!
    var userStellar: StellarAccount!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        //        self.addLeftBarButtonWithImage(UIImage(named: "ic_menu")!)
//        self.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadData()
    }
    
    func loadData() {
        let param : [String : Any] = [:]
        self.startAnimating()
        RequestHandler.getStakeList(parameter: param as NSDictionary, success: { (successResponse) in
                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            self.baseStellar = StellarAccount(fromDictionary: dictionary["base_stellar"] as! [String: Any])
            self.userStellar = StellarAccount(fromDictionary: dictionary["user_stellar"] as! [String: Any])
            
            var coin : StakeCoinModel!
            
            if let coinData = dictionary["stakes"] as? [[String:Any]] {
                self.coinList = [StakeCoinModel]()
                for item in coinData {
                    coin = StakeCoinModel(fromDictionary: item)
                    self.coinList.append(coin)
                }
                self.stakeCoinTable.reloadData()
            }
            
            }) { (error) in
                        self.stopAnimating()
                let alert = Alert.showBasicAlert(message: error.message)
                        self.presentVC(alert)
            }
    }


}

extension StakeListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coinList.count
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        
        let item = coinList[indexPath.row]
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "StakeController") as! StakeController
        vc.coin = item
        vc.baseStellar = self.baseStellar
        vc.userStellar = self.userStellar
        
        self.navigationController?.pushViewController(vc, animated: true)

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: StakeCoin = tableView.dequeueReusableCell(withIdentifier: "StakeCoin", for: indexPath) as! StakeCoin
        let item = coinList[indexPath.row]
        cell.imgIcon.load(url: URL(string: item.icon)!)
        cell.lbSymbol.text = item.symbol
        cell.lbBalance.text = item.balance
        cell.lbStakingAcmount.text = item.staking
        
        
        return cell
    }
}
