//
//  Ext+Double.swift
//  JPMorganWeatherApp
//
//  Created by Xavier Carty on 9/27/24.
//

import Foundation

extension Double {
    var kelvinToFahrenheit: Int {
           return Int((self * 9/5) - 459.67)
    }

    var asFahrenheitString: String {
            return "\(self)°F"
    }

    var toString: String {
        return "\(self)"
    }
}

extension Int {
    var asFahrenheitString: String {
            return "\(self) °F"
    }
}
