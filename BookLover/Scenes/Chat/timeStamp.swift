

import UIKit

class timeStamp: NSObject {
    static let sharedInstance = timeStamp()
    
    override init() {
        super.init()
       
        }
    
    func timeAgoSinceDate(_ date:Date,currentDate:Date, numericDates:Bool) -> String {
        let calendar = Calendar.current
        let now = currentDate
        let earliest = (now as NSDate).earlierDate(date)
        let latest = (earliest == now) ? date : now
        let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())
        
        if (components.year! >= 2) {
            return "\(components.year!) " + localizedTextFor(key: TimeStrings.YearsAgo.rawValue)
        } else if (components.year! >= 1){
            if (numericDates){
                return localizedTextFor(key: TimeStrings.OneYearAgo.rawValue)
            } else {
                return localizedTextFor(key: TimeStrings.LastYear.rawValue)
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) " + localizedTextFor(key: TimeStrings.MonthsAgo.rawValue)
        } else if (components.month! >= 1){
            if (numericDates){
                return localizedTextFor(key: TimeStrings.OneMonthsAgo.rawValue)
            } else {
                return localizedTextFor(key: TimeStrings.LastMonth.rawValue)
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) " + localizedTextFor(key: TimeStrings.WeeksAgo.rawValue)
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return localizedTextFor(key: TimeStrings.OneWeekAgo.rawValue)
            } else {
                return localizedTextFor(key: TimeStrings.LastWeek.rawValue)
            }
        } else if (components.day! >= 2) {
            return "\(components.day!)" + localizedTextFor(key: TimeStrings.DaysAgo.rawValue)
        } else if (components.day! >= 1){
            if (numericDates){
                return localizedTextFor(key: TimeStrings.OneDayAgo.rawValue)
            } else {
                return localizedTextFor(key: TimeStrings.Yesterday.rawValue)
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) " + localizedTextFor(key: TimeStrings.HoursAgo.rawValue)
        } else if (components.hour! >= 1){
            if (numericDates){
                return localizedTextFor(key: TimeStrings.OneHourAgo.rawValue)
            } else {
                return localizedTextFor(key: TimeStrings.OneHourAgo.rawValue)
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) " + localizedTextFor(key: TimeStrings.MinutesAgo.rawValue)
        } else if (components.minute! >= 1){
            if (numericDates){
                return localizedTextFor(key: TimeStrings.OneMinuteAgo.rawValue)
            } else {
                return localizedTextFor(key: TimeStrings.A_MinuteAgo.rawValue)
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) " + localizedTextFor(key: TimeStrings.SecondsAgo.rawValue)
        } else {
            return localizedTextFor(key: TimeStrings.JustNow.rawValue)
        }
    }
    
    func convertDateToLocal(_ date: Date) -> Date {
        let tz = NSTimeZone.local as NSTimeZone
        let seconds: Int? = tz.secondsFromGMT(for: date)
        return Date(timeInterval: TimeInterval(seconds ?? Int(0.0)), since: date)
    }
}
