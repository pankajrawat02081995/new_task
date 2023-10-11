//
//  CommonstructFile.swift
//  Picker
//
//  Created by Developer IOS on 29/05/23.
//

import UIKit
//MARK: - APP INFO
struct AppInfo {
    static let alert = "Alert!"
    static let success = "Success!"
    static let appName = "PickerCustomer"
    static let DeviceType =  "I"
    static let DeviceId =  UIDevice.current.identifierForVendor!.uuidString
    static let appBundleID = Bundle.main.bundleIdentifier ?? "com.app.Picker"
    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
}
//MARK: - VALIDATION REQUEST STRUCT
struct ValidationResult {
    let success: Bool
    let message: String?
}
//MARK: - APP ALERT STRUCT
struct AppAlert {
    var isSuccess = Bool()
    var messageStr = String()
}
//MARK: - RESPONSE HANDLE STRUCT
struct ResponseHandle {
    var data = Data(),
        JSON = NSDictionary(),
        message = String(),
        isSuccess = Bool(),
        statusCode = Int()
}
//MARK: - DATA FORMATS
struct DateFormats {
    static let ddMMyyy = "dd MMM yyyy"
    static let yyyyMMdd = "yyyy MMM dd"
    static let dmy = "dd/MM/yyyy"
    static let mmmDDYYYY = "MMM/dd/yyyy"
    static let hhmma = "hh:mm a"
    static let HHMMSS =  "HH:mm:ss"
    static let HHMM =  "HH:mm"
    static let ymdhmsz =  "yyyy-MM-dd HH:mm:ss zzz"
    static let my =  "MM/yyyy"
    static let YYYYMMDD = "YYYY-MM-dd"
    static let YYYYMMDDHHMMSS = "yyyy-MM-dd HH:mm:ss"
    static let UTCFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    static let walletDate = "MM/dd/yyyy hh:mm a"
}


