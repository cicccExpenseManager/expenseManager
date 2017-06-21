//
//  WishListCell.swift
//  ExpenseManager
//
//  Created by KimSoo Ha on 2017-06-20.
//  Copyright © 2017 Hiroki Honda. All rights reserved.
//

import UIKit

class WishListCell: UITableViewCell {
    
    
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var titleAmount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //Configur the view for the selected state
    }
    
    func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: Locale.current.identifier)
        let result = formatter.string(from: value as NSNumber)
        return result!
    }

}
