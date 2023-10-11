//
//  DateFormatterStyle.swift
//  ChatterBox
//
//  Created by Jitendra Kumar on 25/06/20.
//  Copyright © 2020 Jitendra Kumar. All rights reserved.
//

import Foundation

enum DateFormatterStyle {
    case timeDisplay(timeStyle:DateFormatter.Style)
    case dateDisplay(dateStyle:DateFormatter.Style)
    case dateTimeDisplay(timeStyle :DateFormatter.Style,dateStyle:DateFormatter.Style)
    
    static var formatter:DateFormatter = {
        let formatter = DateFormatter()
        //formatter.locale = LocaleType.en_US.locale
        if let timeZone = TimeZoneType.current.timeZone{
            formatter.timeZone = timeZone
        }else{
            formatter.timeZone = TimeZone.current
        }
        return formatter
    }()
    func result(date:Date)->String{
        switch self {
        case .timeDisplay(let timeStyle):
            if timeStyle == .none  {
                return ""
            }
            DateFormatterStyle.formatter.dateStyle = .none
            DateFormatterStyle.formatter.timeStyle = timeStyle
            return DateFormatterStyle.formatter.string(from: date)
        case .dateDisplay(let dateStyle):
            if dateStyle == .none  {
                return ""
            }
            DateFormatterStyle.formatter.timeStyle = .none
            DateFormatterStyle.formatter.dateStyle = dateStyle
            return DateFormatterStyle.formatter.string(from: date)
        case .dateTimeDisplay(let timeStyle, let dateStyle):
            if timeStyle == .none || dateStyle == .none {
                return ""
            }
            DateFormatterStyle.formatter.timeStyle = timeStyle
            DateFormatterStyle.formatter.dateStyle = dateStyle
            return DateFormatterStyle.formatter.string(from: date)
            
        }
        
    }
    
}
public enum TimeZoneType:CustomStringConvertible {
    case current
    case utc
    case gmt
    case custom(String)
    
    public var timeZone:TimeZone?{
        switch self {
        case .current:
            return TimeZone.current
        case .utc:
            return TimeZone(abbreviation: "UTC")
        case .gmt:
            return TimeZone(abbreviation: "GMT")
        case .custom(let abbreviation):
            return TimeZone(abbreviation: abbreviation)
            
        }
        
    }
    public var description: String{
        switch self {
        case .current:
            return "phone_local TimeZone"
        case .utc:
            return "UTC TimeZone"
        case .gmt:
            return "GMT TimeZone"
        default:
            return "Custom TimeZone"
        }
    }
}
public enum LocaleType:CustomStringConvertible {
    case current
    case autoupdatingCurrent
    case en_US
    case en_US_POSIX
    case custom(String)
    public var locale:Locale{
        switch self {
        case .current: return Locale.current
        case .autoupdatingCurrent:return Locale.autoupdatingCurrent
        case .en_US: return Locale(identifier: "en_US")
        case .en_US_POSIX: return Locale(identifier: "en_US_POSIX")
        case .custom(let abbreviation):return Locale(identifier: abbreviation)
        }
    }
    public var identifier:String{
        return locale.identifier
    }
    public var description: String{
        switch self {
        case .current:
            return "current Local"
        case .autoupdatingCurrent:
            return "autoupdatingCurrent Local"
        case .en_US:
            return "en_US Local"
        case .en_US_POSIX:
            return "en_US_POSIX Local"
        default:
            return "Custom Local"
        }
    }
}

