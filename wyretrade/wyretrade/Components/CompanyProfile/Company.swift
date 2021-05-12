//
//  Company.swift
//  wyretrade
//
//  Created by maxus on 3/5/21.
//

import Foundation
import UIKit

class Company: UIView {
    
    @IBOutlet weak var lbDescription: UILabel!
    @IBOutlet weak var lbIndustry: UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func loadView() -> UIView {
        let bundleName = Bundle(for: type(of: self))
        let nibName = String(describing: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundleName)
        let view = nib.instantiate(withOwner: nil, options: nil).first as! UIView
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}
