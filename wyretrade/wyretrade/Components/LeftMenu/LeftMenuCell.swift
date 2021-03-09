//
//  LeftMenuCell.swift
//  wyretrade
//
//  Created by maxus on 3/8/21.
//

import Foundation
import UIKit

class LeftMenuCell: UITableViewCell {

    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
