//
//  NewsView.swift
//  wyretrade
//
//  Created by maxus on 3/2/21.
//

import Foundation
import UIKit

class NewsView: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var summary: UILabel!
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
