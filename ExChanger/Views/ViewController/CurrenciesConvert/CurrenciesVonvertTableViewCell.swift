//
//  CurrencieTableViewCell.swift
//  ExChanger
//
//  Created by Sabbir Ahmed on 25/7/20.
//  Copyright © 2020 Grey Matter. All rights reserved.
//

import UIKit

class CurrenciesVonvertTableViewCell: UITableViewCell {
    @IBOutlet weak var currenciesName: UILabel!
    @IBOutlet weak var rate: UILabel!
    
    var source = "USD"
    
    var item: Quotes! {
        didSet {
            
            let currencyName = item.currency.replacingOccurrences(of: source, with: "")
            
            if currencyName.isEmpty { return }
            
            currenciesName.text = currencyName
            rate.text = String(item.rate)
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
