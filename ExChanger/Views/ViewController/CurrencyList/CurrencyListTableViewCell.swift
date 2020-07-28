//
//  CurrencyListTableViewCell.swift
//  ExChanger
//
//  Created by Sabbir Ahmed on 26/7/20.
//  Copyright © 2020 Grey Matter. All rights reserved.
//

import UIKit

class CurrencyListTableViewCell: UITableViewCell {
    @IBOutlet weak var currencyName: UILabel!
    
    var item: Currencies! {
        didSet {
            currencyName.text = "\(item.currency)  :  \(item.countryName)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static var identifier: String {
        return String(describing: self)
    }

}
