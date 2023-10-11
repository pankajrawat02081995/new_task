//
//  CommonMethod.swift
//  Picker
//
//  Created by Developer IOS on 29/05/23.
//

import UIKit
//import NVActivityIndicatorView

class CommonMethod {
    //MARK: - SINGLTON CLASS INSTANCE
    static var shared: CommonMethod {
        return CommonMethod()
    }
    fileprivate init(){}
    
    //MARK: - Show Activity Indicator Method
    func showActivityIndicator() {
        DispatchQueue.main.async {
           // let activityData = ActivityData(color: UIColor(named: CustomColor.headerBgColor))
            
           // NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        }
    }
    
    //MARK: - Hide Activity Indicator Method
    func hideActivityIndicator() {
        DispatchQueue.main.async {
           // NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        }
    }
    
    //MARK: - UTC To Local Convert Method
    func UTCToLocal(_ UTCDateString: String,backendFormat:String,needFormat:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = backendFormat //"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.locale = Locale.current
        let UTCDate = dateFormatter.date(from: UTCDateString)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = needFormat
        if UTCDate != nil {
            let UTCToCurrentFormat = dateFormatter.string(from: UTCDate!)
            return UTCToCurrentFormat
        } else {
            return ""
        }
    }
    
    //MARK: - Get Date And Time In String Method
    func getDateAndTimeInStr(getDate:String,backendFormat:String,needDateFormat:String,needTimeFormat:String) -> (String,String) {
        var resultDateInStr = String(),resultTimeInStr = String()
        if getDate != "" {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = backendFormat//"yyyy-MM-dd hh:mm a"
            let dateInStr = dateFormatter.date(from: getDate)
            
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = needDateFormat//"yyyy-MM-dd"
            if dateInStr != nil {
                resultDateInStr = dateFormatter1.string(from: dateInStr!)
            }
            
            dateFormatter1.dateFormat = needTimeFormat//"hh:mm a"
            let timeInStr = dateFormatter.date(from: getDate)
            if timeInStr != nil {
                resultTimeInStr = dateFormatter1.string(from: timeInStr!)
            }
        }
        return (resultDateInStr,resultTimeInStr)
    }
    
    //MARK: - Get String From Date Method
    func getStringFromDate(date: Date,needFormat: String) -> String {
        var dateStr = String()
        if needFormat != "" {
            let formatter = DateFormatter()
            formatter.dateFormat = needFormat
            let locale = Locale.current
            formatter.locale = locale
            dateStr = formatter.string(from: date)
        }
        return dateStr
    }
    
    //MARK: - Get Date From String Method
    func getDateFromSting(string: String,stringFormat: String) -> Date {
        var date = Date()
        if string != "" {
            let formatter = DateFormatter()
            formatter.dateFormat = stringFormat
            let dateInDate = formatter.date(from: string)
            if dateInDate != nil {
                date = dateInDate!
            }
        }
        return date
    }
    
    //MARK: Convert Json String To Object
    func convertJsonStringToObject(_ jsonStr: String,completion:@escaping(_ dict:NSDictionary) -> Void) {
        let data = Data(jsonStr.utf8)
        do {
            if let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                debugPrint("JSON Object:- ",jsonDict as NSDictionary)
                completion(jsonDict as NSDictionary)
            }
        } catch let error as NSError {
            debugPrint("Failed to convert:- ",error.localizedDescription)
            completion([:])
        }
    }
    //MARK: - CHECK PASSWORD 
    func isStrongPassword(_ password: String) -> Bool {
        let passwordRegex = "(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z)])(?=.*[@$%&#]).{8,}"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
    }
    
    // MARK: Is Valid Password
    func isValidPassword(_ password:String) -> Bool {
        let passwordRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{8,}"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: password)
    }
}
