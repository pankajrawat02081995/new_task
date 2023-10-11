

import Foundation
import UIKit

class ColoredNavigationBar: UINavigationBar {
    
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
        tintColor = UIColor.black
        barTintColor = UIColor.init(red: 45/255, green: 70/255, blue: 91/255, alpha: 1.0)
        backgroundColor = UIColor.init(red: 45/255, green: 70/255, blue: 91/255, alpha: 1.0)
        
        //isTranslucent = true
        //shadowImage = UIImage()
        setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        
        titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font:UIFont.systemFont(ofSize: 20, weight: .bold)]
        backIndicatorImage = UIImage(named: "ic_back")?.withRenderingMode(.alwaysOriginal)
        backIndicatorTransitionMaskImage = UIImage(named: "ic_back")
    }
}
