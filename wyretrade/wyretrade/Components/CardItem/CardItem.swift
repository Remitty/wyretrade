//
//  CardItem.swift
//  wyretrade
//
//  Created by brian on 5/14/21.
//

import Foundation
import UIKit

protocol CardItemParaDelegate {
    func deleteCard(id: String, index: Int)
}

class CardItem: UITableViewCell {
    
    @IBOutlet weak var imgIcon: UIImageView!
    
    @IBOutlet weak var lbCardNo: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    
    var delegate: CardItemParaDelegate!
    var id: String!
    var index: Int!
    
    @IBAction func actionRemove(_ sender: Any) {
        
        delegate.deleteCard(id: id, index: index)
    }
}
