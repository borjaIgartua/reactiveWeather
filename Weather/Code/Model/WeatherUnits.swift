//
//  WeatherUnits.swift
//  Weather
//
//  Created by Borja on 19/2/16.
//  Copyright © 2016 Borja. All rights reserved.
//

import Foundation

struct WeatherUnits {
    
    static var metricUnits : String {
        get {
            
            let countryCode = (Locale.current as NSLocale).object(forKey: NSLocale.Key.countryCode) as! String
            if countryCode.lowercased().contains("us") {
                return "imperial"
                
            } else {
                return "metric"
            }
        }
    }
    
    static var temperatureSymbol : String {
        get {
            let countryCode = (Locale.current as NSLocale).object(forKey: NSLocale.Key.countryCode) as! String
            if countryCode.lowercased().contains("us") {
                return "F"
                
            } else {
                return "°"
            }
        }
    }
    
    static var windSymbol : String {
        get {
            let countryCode = (Locale.current as NSLocale).object(forKey: NSLocale.Key.countryCode) as! String
            if countryCode.lowercased().contains("us") {
                return "miles/hour"
                
            } else {
                return "meters/sec"
            }
        }
    }
    
}
