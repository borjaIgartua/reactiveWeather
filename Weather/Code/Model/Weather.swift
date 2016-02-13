//
//  Weather.swift
//  Weather
//
//  Created by Borja on 13/2/16.
//  Copyright © 2016 Borja. All rights reserved.
//

import Foundation

struct Weather {
    
    var id : String
    var mainDescription : String
    var description : String
    
    var temperature : Double
    var temperatureMax : Double
    var temperatureMin : Double
    
    var pressure: Double
    var humidity : Double
    var windSpeed : Double
    
    init(withID id: String, mainDescription: String, description: String,
        temperature : Double, temperatureMax : Double, temperatureMin : Double,
        pressure : Double, humidity : Double, windSpeed : Double) {
        
        self.id = id
        self.mainDescription = mainDescription
        self.description = description
        self.temperature = temperature
        self.temperatureMax = temperatureMax
        self.temperatureMin = temperatureMin
        self.pressure = pressure
        self.humidity = humidity
        self.windSpeed = windSpeed
    }
}