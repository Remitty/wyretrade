//
//  LInkAssetController.swift
//  wyretrade
//
//  Created by brian on 3/16/21.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class LinkAssetController: UIViewController, NVActivityIndicatorViewable {

    @IBOutlet weak var assetTable: UITableView! {
        didSet {
            assetTable.delegate = self
            assetTable.dataSource = self
            assetTable.showsVerticalScrollIndicator = false
            assetTable.separatorColor = UIColor.darkGray
            assetTable.separatorStyle = .singleLineEtched
            assetTable.register(UINib(nibName: "AssetView", bundle: nil), forCellReuseIdentifier: "AssetView")
        }
    }
    
    @IBOutlet weak var tableHeightLayout: NSLayoutConstraint!
    
    
    var assetList = [LinkAssetModel]()
    var accountId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        self.dataLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
//       self.navigationController?.isNavigationBarHidden = true
        self.dataLoad()
   }

   override func viewWillDisappear(_ animated: Bool) {
       super.viewWillDisappear(animated)
       self.navigationController?.isNavigationBarHidden = false
   }
    
    func dataLoad() {
        self.startAnimating()
        let param : [String : Any] = ["id": self.accountId]
                RequestHandler.getZaboAccountDetail(parameter: param as NSDictionary, success: { (successResponse) in
                                self.stopAnimating()
                    let dictionary = successResponse as! [String: Any]
                    
                    var asset : LinkAssetModel!
                    
                    if let assetData = dictionary["assets"] as? [[String:Any]] {
                        self.assetList = [LinkAssetModel]()
                        for item in assetData {
                            asset = LinkAssetModel(fromDictionary: item)
                            self.assetList.append(asset)
                        }
                        self.assetTable.reloadData()
                    }
                            
                    
                    
                    }) { (error) in
                        self.stopAnimating()
                        let alert = Alert.showBasicAlert(message: error.message)
                                self.presentVC(alert)
                    }
    }

}

extension LinkAssetController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.estimatedRowHeight = 110
        tableHeightLayout.constant = CGFloat(Double(assetList.count) * 110)
        return assetList.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AssetView = tableView.dequeueReusableCell(withIdentifier: "AssetView", for: indexPath) as! AssetView
        cell.delegate = self
        let item = assetList[indexPath.row]
        if item.icon != "" {
            cell.imgIcon.load(url: URL(string: item.icon)!)
        }
        
        cell.lbBalance.text = item.balance + item.symbol
        if item.name != "" {
            cell.lbName.text = item.name
        } else {
            cell.lbName.text = item.symbol
        }
        
        cell.lbFiatValue.text = item.fiatValue
        cell.accountId = self.accountId
        cell.asset = item.symbol

        return cell
    }
}

extension LinkAssetController: AssetViewParameterDelegate {
    
    func depositParamData(param: NSDictionary) {
        self.startAnimating()
        RequestHandler.createZaboDeposit(parameter: param, success: {(successResponse) in
            self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            var address = dictionary["address"] as! String
            let alertController = UIAlertController(title: "Only send \(param["asset"]!)", message: nil, preferredStyle: .alert)
            let copyAction = UIAlertAction(title: "Copy", style: .default) { (_) in
                let pasteboard = UIPasteboard.general
                pasteboard.string = address
                self.showToast(message: "Copied successfully")
            }
            
            alertController.addTextField { (textField) in
                textField.text = address
            }
            alertController.addAction(copyAction)
            
            self.present(alertController, animated: true, completion: nil)
        
        }) {
            (error) in
                        self.stopAnimating()
            let alert = Alert.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
}
