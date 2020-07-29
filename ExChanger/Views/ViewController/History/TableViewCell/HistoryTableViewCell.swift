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
        dateTime.text = ExchangerUtil.sharedInstance().dateAsString(dt)
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
        dateTime.text = ExchangerUtil.sharedInstance().dateAsString(Date())
        baseKeyName.text = ""
        baseValue.text = String(describing: 0.00)
        targetKeyName.text = ""
        targetValue.text = String(describing: 0.00)
    }
    
}
