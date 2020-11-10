//
//  Date+Extension.swift
//  AlmaFramework-iOS
//
//  Created by Laura Pugliese on 24/03/2020.
//  Copyright © 2020 Almaviva Spa. All rights reserved.
//

import Foundation

extension Date {
    
    public static let ddMMyyyy:String = "dd/MM/yyyy"
    public static let ddMMyy:String = "dd/MM/yy"
    public static let ddMMMyyyy:String = "dd-MMM-yyyy"
    public static let yyyyMMdd:String = "yyyy-MM-dd"
    public static let HHmmss:String = "HH.mm.ss"
    public static let ddMMyyyyHHmmss:String = "dd/MM/yyyy HH:mm.ss"
    public static let ddMMyyyyHHmm:String = "dd/MM/yyyy HH:mm"
    public static let yyyyMMddHHmm:String = "yyyyMMddHHmm"

    /// Returns the amount of years from another date
    public func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    public func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    public func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfYear], from: date, to: self).weekOfYear ?? 0
    }
    /// Returns the amount of days from another date
    public func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    public func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    public func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    public func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    public func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }


    public func currentYear() -> Int{
        let calendar = Calendar.current
        return calendar.component(.year, from: self)
    }

    public func currentMonth()->Int{
        let calendar = Calendar.current
        return calendar.component(.month, from: self)
    }
    public func currentDay()->Int{
        let calendar = Calendar.current
        return calendar.component(.day, from: self)
    }

    public func currentHour()->Int{
        let calendar = Calendar.current
        return calendar.component(.hour, from: self)
    }

    public func currentMinutes()->Int{
        let calendar = Calendar.current
        return calendar.component(.minute, from: self)
    }

    public func currentSeconds()->Int{
        let calendar = Calendar.current
        return calendar.component(.second, from: self)
    }

    public func addMonth(n: Int) -> Date {
        let cal = NSCalendar.current
        return cal.date(byAdding: .month, value: n, to: self)!
    }
    public func addDay(n: Int) -> Date {
        let cal = NSCalendar.current
        return cal.date(byAdding: .day, value: n, to: self)!
    }
    public func addHour(n: Int) -> Date {
        let cal = NSCalendar.current
        return cal.date(byAdding: .hour, value: n, to: self)!
    }
    public func addMinutes(n: Int) -> Date {
        let cal = NSCalendar.current
        return cal.date(byAdding: .minute, value: n, to: self)!
    }
    public func addSeconds(n: Int) -> Date {
        let cal = NSCalendar.current
        return cal.date(byAdding: .second, value: n, to: self)!
    }

    public func addSec(n: Int) -> Date {
        let cal = NSCalendar.current
        return cal.date(byAdding: .second, value: n, to: self)!
    }

    public var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
    public var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }

    public func toString(format:String, timeZone:String?=nil)->String{
        let dateFormatter = DateFormatter()
        if timeZone != nil && timeZone!.count==3{
            dateFormatter.timeZone = TimeZone(abbreviation: timeZone!)
        }
        dateFormatter.dateFormat = format //Your New Date format as per requirement change it own
        return dateFormatter.string(from: self) //pass Date here
    }

    public func dayBefore()->String{

        if self.days(from: Date().setTime(hour: 0, min: 0, sec: 0)!) == 0{ return "Oggi" }
        if self.days(from: Date().setTime(hour: 0, min: 0, sec: 0)!) == -1{ return "Ieri" }
        if self.days(from: Date().setTime(hour: 0, min: 0, sec: 0)!) < -1
            && self.days(from: Date().setTime(hour: 0, min: 0, sec: 0)!) > -9{

            let dateFormatter = DateFormatter()

            dateFormatter.locale = Locale.current
            dateFormatter.dateFormat = "EEEE"
            return dateFormatter.string(from: self)
        }
        if self.days(from: Date()) > 9{

            let dateFormatter = DateFormatter()

            dateFormatter.locale = Locale.current
            dateFormatter.dateFormat = "dd MMM"
            return dateFormatter.string(from: self)
        }

        let dateFormatter = DateFormatter()

        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "dd MMM YY"
        return dateFormatter.string(from: self)

    }

    
    public func timeStamp(format:String) -> String{
        let now = self
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = format
        return formatter.string(from: now)
    }
    
    public func formatString(format: String = Date.ddMMyyyy, timeZone: TimeZone? = nil, timeZoneAbbrev: String? = nil, locale: Locale? = Locale.current, capitalized: Bool = false) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = locale
        if let timeZoneAbbrev = timeZoneAbbrev {
            dateFormatter.timeZone = TimeZone(abbreviation: timeZoneAbbrev)
        }
        if let timezone = timeZone{
            dateFormatter.timeZone = timezone
        }
        dateFormatter.dateFormat = format
        let result = dateFormatter.string(from: self)
        return capitalized ? result.capitalized : result
    }
    
    public func setTime(hour: Int, min: Int, sec: Int, timeZoneIdentifier: String? = nil) -> Date? {
        let x: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let cal = Calendar.current
        var components = cal.dateComponents(x, from: self)
        if let timeZone = timeZoneIdentifier {
            components.timeZone = TimeZone(identifier: timeZone)
        } else {
            components.timeZone = TimeZone.current
        }
        components.hour = hour
        components.minute = min
        components.second = sec
        
        return cal.date(from: components)
    }
    
}
