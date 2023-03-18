//
//  PTDateFormatter.swift
//  ChatterBox
//
//  Created by Jitendra Kumar on 25/06/20.
//  Copyright © 2020 Jitendra Kumar. All rights reserved.
//

import Foundation


enum DateFormatType {
    case isoDateTime
    case isoDateTimeSec
    case isoDateTimeMilliSec
    
    /// A custom date format string
    case custom(String)
    var stringFormat:String {
        switch self {
        case .isoDateTime: return  "MMM,dd 'at' h:mm a"
        case .isoDateTimeSec: return "yyyy-MM-dd'T'HH:mm:ss.SSS"
        case .isoDateTimeMilliSec: return "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        case .custom(let customFormat): return customFormat
        }
    }
}
struct PTDateFormatter {
    var timeZoneType :TimeZoneType?
    var formater:DateFormatType
    var locateType:LocaleType?
    
    init(timeZoneType :TimeZoneType? = nil,formater:DateFormatType, locateType:LocaleType? = nil) {
        self.timeZoneType = timeZoneType
        self.formater = formater
        self.locateType = locateType
    }
    
    
    func dateFormatter(dateString:String,serverFormat:PTDateFormatter,localFormat:PTDateFormatter)->(date:Date?,dateTimeStr:String?){
        if dateString.isEmpty {
            return (nil,nil)
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = serverFormat.formater.stringFormat
        if let timeZoneType = serverFormat.timeZoneType{
            dateFormatter.timeZone = timeZoneType.timeZone
        }
        if let locateType = serverFormat.locateType{
            dateFormatter.locale = locateType.locale
        }
        
        if let date = dateFormatter.date(from: dateString){ // create date from string
            // change to a readable time format and change to local time zone
            dateFormatter.dateFormat = localFormat.formater.stringFormat
            if let timeZoneType = localFormat.timeZoneType{
                dateFormatter.timeZone = timeZoneType.timeZone
            }
            if let locateType = localFormat.locateType{
                dateFormatter.locale = locateType.locale
            }
            let dateStamp = dateFormatter.string(from: date)
            return (date,dateStamp)
        }else{
            return (nil,nil)
        }
        
        
        
        
        
    }
}
enum DateFormatterType{
    
    case string(timeZoneType :TimeZoneType,formater:DateFormatType)
    case date(timeZoneType :TimeZoneType,formater:DateFormatType)
    
    func formatter(date:Date)->Any?{
        switch self {
        case .string(let timeZoneType,let formater):
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = formater.stringFormat
            dateFormatter.timeZone = timeZoneType.timeZone
            let dateStamp = dateFormatter.string(from: date)
            return dateStamp
        case .date(let timeZoneType,let formater):
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = formater.stringFormat
            dateFormatter.timeZone = timeZoneType.timeZone
            let dateStamp = dateFormatter.string(from: date)
            let newdate = dateFormatter.date(from: dateStamp)
            return newdate
        }
    }
}
