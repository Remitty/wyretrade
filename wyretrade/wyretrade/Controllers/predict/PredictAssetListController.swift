//
//  PredictAssetListController.swift
//  wyretrade
//
//  Created by brian on 3/24/21.
//

import Foundation
import UIKit

class PredictAssetListController: UIViewController, UISearchBarDelegate {
    
    
    @IBOutlet weak var assetTable: UITableView! {
        didSet {
            assetTable.delegate = self
            assetTable.dataSource = self
            assetTable.showsVerticalScrollIndicator = false
            assetTable.separatorColor = UIColor.darkGray
            assetTable.separatorStyle = .singleLineEtched
            assetTable.register(UINib(nibName: "PredictionAssetItem", bundle: nil), forCellReuseIdentifier: "PredictionAssetItem")
        }
    }
    
    @IBOutlet weak var searchCoins: UISearchBar!
    
    
    var assetList = [PredictAssetModel]()
    var usdcBalance = ""
    var filtered:[PredictAssetModel] = []
    var isFiltering: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchCoins.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        
        if searchText != "" {
            isFiltering = true
        }
        filtered = self.assetList.filter({ (asset: PredictAssetModel) -> Bool in
            
            return asset.symbol.lowercased().contains(searchText.lowercased())
        })
        if filtered.count == 0 {
            isFiltering = false
        }
        self.assetTable.reloadData()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}

extension PredictAssetListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filtered.count
        }
        return assetList.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let item: PredictAssetModel!
        if isFiltering {
            item = filtered[indexPath.row]
        } else {
            item = assetList[indexPath.row]
        }
        
        let detailController = storyboard?.instantiateViewController(withIdentifier: "PredictionPostController") as! PredictionPostController
        detailController.usdcBalance = self.usdcBalance
//        detailController.asset = item
        detailController.symbol = item.symbol
        detailController.name = item.name
        detailController.price = item.price
        detailController.kind = 0
//        detailController.id = item.id
        
        self.navigationController?.pushViewController(detailController, animated: true)

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PredictionAssetItem = tableView.dequeueReusableCell(withIdentifier: "PredictionAssetItem", for: indexPath) as! PredictionAssetItem
        
        let item: PredictAssetModel!
        if isFiltering {
            item = filtered[indexPath.row]
        } else {
            item = assetList[indexPath.row]
        }
        
        cell.imgIcon.load(url: URL(string: item.icon)!)
        cell.lbChangePercent.text = item.changeToday
        cell.lbName.text = item.name
        cell.lbPrice.text = item.price
        cell.lbSymbol.text = item.symbol
        
        return cell
    }
}
