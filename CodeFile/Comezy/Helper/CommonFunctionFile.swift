//
//  CommonFunctionFile.swift
//  Picker
//
//  Created by Developer IOS on 29/05/23.
//

import UIKit

// MARK: Common Variables
var currentCont = UIViewController()
var appDelegateObj = UIApplication.shared.delegate as! AppDelegate

// MARK: Get Storyboard
func getStoryboard(_ storyType:Storyboards) -> UIStoryboard {
    return UIStoryboard(name: storyType.rawValue, bundle: nil)
}

// MARK: App Font Method
func AppFont(_ name: String,size:CGFloat) -> UIFont {
    return UIFont(name: name, size: size)!
}

// MARK: Show Price In Decimal Number
func showPriceInDecimalNumber(_ amount:Double) -> String {
    let etherPrice = String(amount)
    let decimalValue = NSDecimalNumber(string: etherPrice)
    return "\(decimalValue)"
}

// MARK: Show Price In Decimal Number
func showPriceInDecimalNbr(_ amount:Double) -> Double {
    let decimalValue = NSDecimalNumber(value: amount)
    return Double(truncating: decimalValue)
}

// MARK: Random String
func randomString(length: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let randomStr = String((0..<length).map { _ in letters.randomElement()! })
    let randomWithTime = "\(Date().timeIntervalSince1970)\(randomStr)"
    debugPrint("Random String:- ",randomWithTime)
    return randomWithTime
}

// MARK: Get Integer Value
func getIntegerValue(_ value:Any) -> Int {
    var integerValue = Int()
    if let getVal = value as? String {
//        if getVal.isNumeric && getVal != "" {
//            integerValue = Int(getVal) ?? 0
//        }
    } else if let getVal = value as? Int {
        integerValue = getVal
    } else if let getVal = value as? Double {
        integerValue = Int(getVal)
    } else if let getVal = value as? Bool {
        integerValue = getVal ? 1 : 0
    }
    return integerValue
}

// MARK: Get String Value
func getStringValue(_ value:Any) -> String {
    var strValue = String()
    if let getVal = value as? String {
        strValue = getVal
    } else if let getVal = value as? Int {
        strValue = String(getVal)
    } else if let getVal = value as? Double {
        strValue = String(getVal)
    }
    return strValue
}

// MARK: Is Valid Password
func isValidPassword(_ password:String) -> Bool {
    let passwordRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$"
    let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
    return passwordTest.evaluate(with: password)
}
