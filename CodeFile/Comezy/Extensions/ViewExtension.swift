//
//  extensions.swift
//  InsuranceCalculator
//
//  Created by MAC on 29/04/20.
//  Copyright © 2020 MAC. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

extension UIView {
    
    @IBInspectable var mCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var mBorderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var mBorderColor: UIColor {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable var circular: Bool {
        get {
            return false
        }
        set {
            if newValue {
                makeCircular()
            }
        }
    }
    
    @IBInspectable var shadow: Bool {
        get {
            return false
        }
        set {
            if newValue {
                addShadow()
            }
        }
    }
    
    func makeCircular() {
        layer.cornerRadius = min(self.frame.size.height, self.frame.size.width)/2
        layer.masksToBounds = true
    }
    
    func addShadow() {
        self.layer.shadowColor = UIColor.init(red: 170/255, green: 170/255, blue: 170/255, alpha: 1).cgColor
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 4.0//mCornerRadius
    }
}

extension UIImageView {
    
    
    
    
    
    
    
    func placeImage(from url: URL, contentMode mode: ContentMode = .scaleAspectFill){
        
        
        
        contentMode = mode
        
        
        
        let processor = DownsamplingImageProcessor(size: bounds.size)
        
        
        
        kf.indicatorType = .activity
        
        
        
        kf.setImage(
            
            
            
            with: url,
            
            
            
            placeholder: UIImage(named: ""),
            
            
            
            options: [
                
                
                
                .processor(processor),
                
                
                
                    .loadDiskFileSynchronously,
                
                
                
                    .cacheOriginalImage,
                
                
                
                    .transition(.fade(0.25))
                
                
                
            ],
            
            
            
            progressBlock: { receivedSize, totalSize in
                
                
                
                // Progress updated
                
                
                
            },
            
            
            
            completionHandler: { result in
                
                
                
                // Done
                
                
                
            }
            
            
            
        )
        
        
        
        
        
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    func placeImage(from link: String, contentMode mode: ContentMode = .scaleAspectFill) {
        
        
        
        guard let url = URL(string: link) else { return }
        
        
        
        placeImage(from: url, contentMode: mode)
        
        
        
    }
    
}

extension UIView {
    func addDashedBorder() {
        let color = UIColor.black.cgColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 2
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [6,3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 4).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
}
