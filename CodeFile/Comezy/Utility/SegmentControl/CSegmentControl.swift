//
//  TabBarVC.swift
//  SoundTide
//
//  Created by mandeepkaur on 01/04/21.
//

import UIKit

@IBDesignable
class CSegmentControl: UISegmentedControl {
    
    
    @IBInspectable
    var selectedTextColor:UIColor = .black{
        didSet{
            self.setNeedsDisplay()
        }
    }
    @IBInspectable
    var textColor:UIColor = .lightGray{
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var bgColor:UIColor = .black{
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var bgGreenColor:UIColor = App.Colors.appGreenColor ?? .green{
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var cornerRadius:CGFloat = 9{
        didSet {
            self.setNeedsDisplay()
        }
    }
    override func layoutSubviews(){
        super.layoutSubviews()
        
        let segmentStringSelected: [NSAttributedString.Key : Any] = [
            //NSAttributedString.Key.font : selectedFont,
            NSAttributedString.Key.foregroundColor : selectedTextColor
        ]
        
        let segmentStringHighlited: [NSAttributedString.Key : Any] = [
            //NSAttributedString.Key.font : font,
            NSAttributedString.Key.foregroundColor : textColor
        ]
        
        let segmentStringNormal: [NSAttributedString.Key : Any] = [
            //NSAttributedString.Key.font : font,
            NSAttributedString.Key.foregroundColor : bgColor
        ]
        
        setTitleTextAttributes(segmentStringNormal, for: .normal)
        setTitleTextAttributes(segmentStringSelected, for: .selected)
        setTitleTextAttributes(segmentStringHighlited, for: .highlighted)
        
        layer.masksToBounds = true
        
        //corner radius
        let maskedCorners: CACornerMask = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        //background
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = maskedCorners
        self.backgroundColor = UIColor.white
        let foregroundIndex = numberOfSegments
        if subviews.indices.contains(foregroundIndex),
           let foregroundImageView = subviews[foregroundIndex] as? UIImageView {
            foregroundImageView.image = UIImage()
            foregroundImageView.clipsToBounds = true
            foregroundImageView.layer.masksToBounds = true
            if #available(iOS 13.0, *) {
                foregroundImageView.backgroundColor = .clear// selectedSegmentTintColor
            } else {
                foregroundImageView.backgroundColor = .clear// tintColor
            }
            
            
            foregroundImageView.layer.cornerRadius = cornerRadius
            foregroundImageView.layer.maskedCorners = maskedCorners
            
            let bottomBorder = CALayer()
            bottomBorder.backgroundColor = bgGreenColor.cgColor
            bottomBorder.frame = CGRect(x: 0, y: self.frame.size.height, width: self.frame.size.width, height: 5)
            foregroundImageView.layer.addSublayer(bottomBorder)
            
        }
        
        
        
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
}



