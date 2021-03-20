//
//  LinkWalletController.swift
//  wyretrade
//
//  Created by maxus on 3/8/21.
//

import Foundation
import UIKit


class LinkAccountController: UIViewController {

    @IBOutlet weak var accountTable: UITableView! {
        didSet {
            accountTable.delegate = self
            accountTable.dataSource = self
            accountTable.showsVerticalScrollIndicator = false
            accountTable.separatorColor = UIColor.darkGray
            accountTable.separatorStyle = .singleLineEtched
            accountTable.register(UINib(nibName: "AccountView", bundle: nil), forCellReuseIdentifier: "AccountView")
        }
    }
    
    var accountList = [LinkAccountModel]()
    var clientId = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //        self.addLeftBarButtonWithImage(UIImage(named: "ic_menu")!)
        
        self.loadData()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//       super.viewWillAppear(animated)
//       self.navigationController?.isNavigationBarHidden = true
//
//   }
//
//   override func viewWillDisappear(_ animated: Bool) {
//       super.viewWillDisappear(animated)
//       self.navigationController?.isNavigationBarHidden = false
//   }
    
    func loadData() {
        let param : [String : Any] = [:]
                RequestHandler.getZaboAccounts(parameter: param as NSDictionary, success: { (successResponse) in
        //                        self.stopAnimating()
                    let dictionary = successResponse as! [String: Any]
                    
                    var account : LinkAccountModel!
                    
                    if let Data = dictionary["accounts"] as? [[String:Any]] {
                        self.accountList = [LinkAccountModel]()
                        for item in Data {
                            account = LinkAccountModel(fromDictionary: item)
                            self.accountList.append(account)
                        }
                        self.accountTable.reloadData()
                    }
                            
                    self.clientId = dictionary["client_id"] as! String
                    
                    
                    }) { (error) in
                        let alert = Alert.showBasicAlert(message: error.message)
                                self.presentVC(alert)
                    }
    }


    @IBAction func actionConnect(_ sender: Any) {
        let base = "https://connect.zabo.com/connect"
        let apiKey = "?client_id=\(clientId)"
        let origin = "&origin=localhost"
        let env = "&zabo_env=sandbox"
        let version = "&zabo_version=latest"
        let redirect = "&redirect_url=\(Constants.URL.ZABO_REDIRECT)"
         let url = base + apiKey + origin + env + version + redirect
        
        let webviewController = storyboard?.instantiateViewController(withIdentifier: "webVC") as! webVC
        webviewController.url = url
        self.navigationController?.pushViewController(webviewController, animated: true)
        
    }
}

extension LinkAccountController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountList.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        
        let item = accountList[indexPath.row]
        
        let detailController = storyboard?.instantiateViewController(withIdentifier: "LinkAssetController") as! LinkAssetController
        detailController.accountId = item.id
        
        self.navigationController?.pushViewController(detailController, animated: true)

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AccountView = tableView.dequeueReusableCell(withIdentifier: "AccountView", for: indexPath) as! AccountView
        let item = accountList[indexPath.row]
        cell.lbAsset.text = item.account
        cell.lbBalance.text = item.balance
        cell.lbAssetCnt.text = item.assetCount + "Assets"

        return cell
    }
}
