//
//  Date+Ex.swift
//   ChatterBox
//
//  Created by Jitendra Kumar on 22/05/20.
//  Copyright © 2019 Jitendra Kumar. All rights reserved.
//

import Foundation


//MARK:- EXTENSION FOR DATE
extension Date {
    
    func toDateFormatter(style:DateFormatterStyle)->String{
        return style.result(date: self)
    }
    
    // convert Date to string date
    func toString(timeZoneType type:TimeZoneType = .current,formater:DateFormatType) -> String{
        return DateFormatterType.string(timeZoneType: type, formater: formater).formatter(date: self) as? String ?? ""
    }
    
    func toDate(timeZoneType type:TimeZoneType = .current,formater:DateFormatType) -> Date?{
        return DateFormatterType.date(timeZoneType: type, formater: formater).formatter(date: self) as? Date
    }
    
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
    func futureDate(_ component: Calendar.Component = .day, value: Int = 45)->Date{
        Calendar.current.date(byAdding: component, value: value, to: self)!
    }
   
}

extension Date{
    /// Returns a Boolean value indicating whether the value of the first
    /// argument is equal to that of the second argument.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    static func ==(lhs:Date, rhs: Date) -> Bool {
        return lhs.compare(rhs) == .orderedSame ? true : false
    }
    /// Returns a Boolean value indicating whether the value of the first
    /// argument is greater than to that of the second argument.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    static func >(lhs:Date, rhs: Date) -> Bool {
        return lhs.compare(rhs) == .orderedDescending
    }
    /// Returns a Boolean value indicating whether the value of the first
    /// argument is greater than or equal to that of the second argument.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    static func >=(lhs:Date,rhs: Date) -> Bool {
        return (lhs.compare(rhs) == .orderedDescending || lhs.compare(rhs) == .orderedSame)
    }
    /// Returns a Boolean value indicating whether the value of the first
    /// argument is less than to that of the second argument.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    static func <(lhs:Date, rhs: Date) -> Bool {
        return lhs.compare(rhs) == .orderedAscending
    }
    /// Returns a Boolean value indicating whether the value of the first
    /// argument is less than or equal to that of the second argument.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    static func <=(lhs:Date, rhs: Date) -> Bool {
        return (lhs.compare(rhs) == .orderedAscending || lhs.compare(rhs) == .orderedSame)
    }
    
    
    
    
}


extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
}

extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
}

extension Date {
    static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate
        
        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }
    

}

