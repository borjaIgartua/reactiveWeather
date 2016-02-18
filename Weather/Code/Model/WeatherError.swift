//
//  WeatherError.swift
//  Weather
//
//  Created by Borja on 18/2/16.
//  Copyright © 2016 Borja. All rights reserved.
//

import Foundation

// an enumeration that is used for generating NSError codes
enum WeatherError: Int {
    
    case InvalidResponse = 0,
    ParserError,
    NoError
    
    func toError() -> NSError {
        return NSError(domain:"Weather", code: self.rawValue, userInfo: nil)
    }
}