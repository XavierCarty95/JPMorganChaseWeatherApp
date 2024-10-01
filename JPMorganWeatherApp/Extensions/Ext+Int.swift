//
//  Ext+Int.swift
//  JPMorganWeatherApp
//
//  Created by Xavier Carty on 9/27/24.
//

import Foundation

extension Int {
    func unixToDateString(timezoneOffset: Int, format: String = "M/dd/yy HH:mm") -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(secondsFromGMT: timezoneOffset)
        return dateFormatter.string(from: date)
    }

    var toString: String {
        return "\(self)"
    }
}
