//
//  NotificationCenter.swift
//  SoundTide
//
//  Created by MAC on 30/04/21.
//

import Foundation

extension NotificationCenter {
    func setObserver(_ observer: AnyObject, selector: Selector, name: String?, object: AnyObject?) {
        NotificationCenter.default.removeObserver(observer, name: name.map { NSNotification.Name(rawValue: $0) }, object: object)
        NotificationCenter.default.addObserver(observer, selector: selector, name: name.map { NSNotification.Name(rawValue: $0) }, object: object)
    }
    
}

extension Notification.Name {
    static let stopPlayer = Notification.Name("stopPlayer")
}
