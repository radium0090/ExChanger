import UIKit

class ExchangerUtil {
    
    // singleton
    class func sharedInstance() -> ExchangerUtil {
        struct Static {
            static let instance = ExchangerUtil()
        }
        return Static.instance
    }
    
    // resize util
    func resizeImg(_ img: UIImageView, w: Double, h: Double) {
        img.frame = CGRect(x: 0, y: 0, width: w, height: h)
    }

    // date convert to string with custom format
    func dateAsString(_ date: Date, dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        let date = formatter.string(from: date)
        return date
    }
}
