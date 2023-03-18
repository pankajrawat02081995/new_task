//
//  EdgeInsets.swift
//  ChatterBox
//
//  Created by Jitendra Kumar on 22/05/20.
//  Copyright © 2020 Jitendra Kumar. All rights reserved.
//


import UIKit

extension UIEdgeInsets{
    @discardableResult
    public static func all(_ value:CGFloat)->UIEdgeInsets{
        return UIEdgeInsets(top: value, left: value, bottom:value, right: value)
    }
    @discardableResult
    public static func onlyLeft(_ left: CGFloat)->UIEdgeInsets{
        return UIEdgeInsets.only(left: left)
    }
    @discardableResult
    public static func onlyRight(_ right: CGFloat)->UIEdgeInsets{
        return UIEdgeInsets.only(right: right)
    }
    @discardableResult
    public static func onlyTop(_ top: CGFloat)->UIEdgeInsets{
        return UIEdgeInsets.only(top: top)
    }
    
    @discardableResult
    public static func onlyBottom(_ bottom: CGFloat)->UIEdgeInsets{
        return UIEdgeInsets.only(bottom: bottom)
    }
    @discardableResult
    public static func only(top: CGFloat = 0.0, left: CGFloat = 0.0, bottom: CGFloat = 0.0, right: CGFloat = 0.0)->UIEdgeInsets{
        return UIEdgeInsets(top: top, left: left, bottom:bottom, right: right)
    }
    @discardableResult
    public static func symmetric(vertical: CGFloat = 0.0, horizontal: CGFloat = 0.0)->UIEdgeInsets{
        return UIEdgeInsets(top: vertical, left: horizontal, bottom:vertical, right: horizontal)
    }
    @discardableResult
    public static func horizontal(left: CGFloat = 0.0, right: CGFloat = 0.0)->UIEdgeInsets{
        return UIEdgeInsets(top: 0.0, left: left, bottom:0.0, right: right)
    }
    @discardableResult
    public static func vertical(top: CGFloat = 0.0, bottom: CGFloat = 0.0)->UIEdgeInsets{
        return UIEdgeInsets(top: top, left: 0.0, bottom:bottom, right: 0.0)
    }
}


