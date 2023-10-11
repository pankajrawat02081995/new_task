
import Foundation
import UIKit

class TransparentNavigationBar: UINavigationBar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    fileprivate func commonInit() {
        barStyle = .default
        tintColor = UIColor.white
        barTintColor = UIColor.clear
        backgroundColor = UIColor.clear
        isTranslucent = true
        setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        shadowImage = UIImage()
        titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        backIndicatorImage = UIImage(named: "ic_back")?.withRenderingMode(.alwaysTemplate)
        backIndicatorTransitionMaskImage = UIImage(named: "ic_back")
    }
}
