//
//  Weather.swift
//  Weather
//
//  Created by Borja on 13/2/16.
//  Copyright © 2016 Borja. All rights reserved.
//

import Foundation

struct Weather {
    
    var descriptions = [WeatherDescription]()
    
    var temperature : Double?
    var temperatureMax : Double?
    var temperatureMin : Double?
    
    var pressure: Double?
    var humidity : Double?
    var windSpeed : Double?
    
    init(responseData: JSON) {
        
        self.temperature = 0
        self.temperatureMax = 0
        self.temperatureMin = 0
        self.pressure = 0
        self.humidity = 0
        self.windSpeed = 0
        
        let weatherResponse = responseData["weather"].arrayValue
        for json in weatherResponse {
            self.descriptions.append(WeatherDescription(responseData: json))
        }
    
        let mainResponseData = responseData["main"].dictionaryValue
        self.humidity = mainResponseData["humidity"]?.doubleValue
        self.temperature = mainResponseData["temp"]?.doubleValue
        self.temperatureMax = mainResponseData["temp_max"]?.doubleValue
        self.temperatureMin = mainResponseData["temp_min"]?.doubleValue
        self.pressure = mainResponseData["pressure"]?.doubleValue
        
        let windResponseData = responseData["wind"].dictionaryValue
        self.windSpeed = windResponseData["speed"]?.doubleValue
    }
}

struct WeatherDescription {
    
    var id : String
    var mainDescription : String
    var description : String
    
    init(responseData: JSON) {
        
        self.id = responseData["id"].stringValue
        self.mainDescription = responseData["main"].stringValue
        self.description = responseData["description"].stringValue
    }
}