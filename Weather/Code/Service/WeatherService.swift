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
    
    static func fetchCurrentWeather(forCity city: String) -> SignalProducer<City?, NSError> {
        
        let session = NSURLSession.sharedSession()
        let currentWeatherURL = NSURL(string: URLRetrieveCurrentWeather, parameters: [("appid", API_WEATHER_KEY), ("q", city)])!
        let request = NSMutableURLRequest(URL: currentWeatherURL)
        request.HTTPMethod = "GET"
        
        return session.rac_dataWithRequest(request)
            .map { data, response in
                
                let json = JSON(data: data)
                return City(responseData: json)
            }
        .retry(3)
        .mapError { error in
            return error
        }
    }
}
