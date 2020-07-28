import UIKit

class IndicatorView {
    fileprivate var view : UIView!
    
    func showIndicator(parentView: UIView) {
        view = UIView(frame: parentView.bounds)
        view.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        
        let indicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        indicatorView.center = view.center
        indicatorView.startAnimating()
        view.addSubview(indicatorView)
        parentView.addSubview(view)
    }
    
    func removeIndicator() {
        view.removeFromSuperview()
        view = nil
    }
}
