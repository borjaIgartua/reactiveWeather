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
    
    func fetchCurrentWeather(forCity city: String) -> SignalProducer<City?, NSError> {
        
        let session = NSURLSession.sharedSession()
        let currentWeatherURL = NSURL(string: URLRetrieveCurrentWeather, parameters: [("appid", API_WEATHER_KEY), ("q", city.encodedQueryURL), ("units" , WeatherUnits.metricUnits)])!
        let request = NSMutableURLRequest(URL: currentWeatherURL)
        request.HTTPMethod = "GET"
        print("Request data: \n \(request)")
        
        return session.rac_dataWithRequest(request)
            .map { data, response in
                
                let json = JSON(data: data)
                if json != nil {
                    print("Data received: \n \(json)")
                    return City(responseData: json)
                    
                } else {
                    return nil
                }
            }
            .retry(3)
            .mapError { error in
                return error
            }
    }
}
