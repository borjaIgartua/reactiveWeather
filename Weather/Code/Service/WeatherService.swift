//
//  WeatherService.swift
//  Weather
//
//  Created by Borja on 13/2/16.
//  Copyright © 2016 Borja. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveSwift
import CoreLocation

struct WeatherService {
    
    func fetchCurrentWeather(forLocation location:CLLocation?) -> SignalProducer<City?, NSError> {
        
        let session = URLSession.shared
        let currentWeatherURL = URL(string: URLRetrieveCurrentWeather, parameters: [("appid", API_WEATHER_KEY), ("lat", location?.encodedQueryURL.0), ("lon", location?.encodedQueryURL.1), ("units" , WeatherUnits.metricUnits)])!
        var request = URLRequest(url: currentWeatherURL)
        request.httpMethod = "GET"
        print("Request data: \n \(request)")
        
        return session.reactive.data(with: request)
            .map { (data, response) -> City? in

            let json = JSON(data: data)
            if json != JSON.null {
                print("Data received: \n \(json)")
                return City(responseData: json)

            } else {
                return nil
            }
        }.retry(upTo: 3).mapError { (error) -> NSError in
            return NSError()
        }
        
    }
    
    func fetchCurrentWeather(forCity city: String) -> SignalProducer<City?, NSError> {
        
        let session = URLSession.shared
        let currentWeatherURL = URL(string: URLRetrieveCurrentWeather, parameters: [("appid", API_WEATHER_KEY), ("q", city.encodedQueryURL), ("units" , WeatherUnits.metricUnits)])!
        var request = URLRequest(url: currentWeatherURL)
        request.httpMethod = "GET"
        print("Request data: \n \(request)")
        
        return session.reactive.data(with: request)
            .map { (data, response) -> City? in
                
                let json = JSON(data: data)
                if json != JSON.null {
                    print("Data received: \n \(json)")
                    return City(responseData: json)
                    
                } else {
                    return nil
                }
            }.retry(upTo: 3).mapError { (error) -> NSError in
                return NSError()
        }
    }
    
    func fetchGroupWeather(forCities cities:[City]) -> SignalProducer<[City]?, NSError> {
        
        var citiesID : String = ""
        for city in cities {
            citiesID = citiesID + city.id
            
            if (city != cities.last) {
                citiesID = citiesID + ","
            }
        }
        
        let session = URLSession.shared
        let currentWeatherURL = URL(string: URLRetrieveGroupWeather, parameters: [("id" , citiesID), ("appid", API_WEATHER_KEY), ("units" , WeatherUnits.metricUnits)])!
        var request = URLRequest(url: currentWeatherURL)
        request.httpMethod = "GET"
        print("Request data: \n \(request)")
        
        return session.reactive.data(with: request)
            .map { (data, response) -> [City]? in
            
                let json = JSON(data: data)
                if json != JSON.null {
                    print("Data received: \n \(json)")

                    let citiesData = json["list"].array
                    var cities = [City]()
                    if let citiesData = citiesData {

                        cities = citiesData.map { city in City(responseData: city) }
                        return cities

                    } else {
                        return nil
                    }
                    
                } else {
                    return nil
                }
            }.retry(upTo: 3).mapError { (error) -> NSError in
                return NSError()
        }
    }
}
