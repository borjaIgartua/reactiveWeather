//
//  WeatherService.swift
//  Weather
//
//  Created by Borja on 13/2/16.
//  Copyright © 2016 Borja. All rights reserved.
//

import Foundation
import ReactiveCocoa

struct WeatherService {
    
    func fetchCurrentWeather(forCity city: String) -> SignalProducer<Weather?, NSError> {
        
        let session = NSURLSession.sharedSession()
        let currentWeatherURL = NSURL(string: URLRetrieveCurrentWeather)!.addParameters([("appid", API_WEATHER_KEY), ("q", city)])!
        let request = NSURLRequest(URL: currentWeatherURL)
        
        return session.rac_dataWithRequest(request)
            .map { data, response in
                do {
                    let json = try (NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0)) as? [NSDictionary])?.first
                    print("\(json)")
                    return nil
                } catch {
                    print("Failed to parse menu")
                    return nil
                }
        }
    }
}
