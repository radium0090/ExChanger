//
//  HistoryTableViewCell.swift
//  ExChanger
//
//  Created by 皮皮 on 2020/07/26.
//  Copyright © 2020 Grey Matter. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var dateTime: UILabel!
    @IBOutlet weak var baseKeyName: UILabel!
    @IBOutlet weak var baseValue: UILabel!
    @IBOutlet weak var targetKeyName: UILabel!
    @IBOutlet weak var targetValue: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    func setCell(dt: Date, bk: String, bv: Float, tk: String, tv: Float) {
        imgView?.image = UIImage(named: "convertImg")
        dateTime.text = dateAsString(dt)
        baseKeyName.text = bk
        baseValue.text = String(describing: bv)
        targetKeyName.text = tk
        targetValue.text = String(describing: tv)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imgView?.image = UIImage(named: "convertImg")
        dateTime.text = dateAsString(Date())
        baseKeyName.text = ""
        baseValue.text = String(describing: 0.00)
        targetKeyName.text = ""
        targetValue.text = String(describing: 0.00)
    }
    
    func dateAsString(_ date: Date, dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        let date = formatter.string(from: date)
        return date
    }
    
}
