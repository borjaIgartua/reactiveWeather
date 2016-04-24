//
//  CityViewModel.swift
//  Weather
//
//  Created by Borja on 18/2/16.
//  Copyright © 2016 Borja. All rights reserved.
//

import Foundation
import ReactiveCocoa
import CoreLocation

class CityViewModel {
    
    let nameProperty : ConstantProperty<String>
    let locationProperty : ConstantProperty<CLLocation?>
    
    let temperatureProperty : ConstantProperty<String>
    let pressureProperty : ConstantProperty<String>
    let humidityProperty : ConstantProperty<String>
    let windSpeedProperty : ConstantProperty<String>
    let descriptionsProperty : ConstantProperty<[WeatherDescription]?>
    
    private let city : City
    
    init() {
        
        self.city = City()
        
        nameProperty = ConstantProperty(String.notnilString(city.name))
        locationProperty = ConstantProperty(city.location)
        
        let weather = city.weather
        
        temperatureProperty = ConstantProperty(String.notnilString(weather?.temperature))
        pressureProperty = ConstantProperty(String.notnilString(weather?.pressure))
        humidityProperty = ConstantProperty(String.notnilString(weather?.humidity))
        windSpeedProperty = ConstantProperty(String.notnilString(weather?.windSpeed))
        descriptionsProperty = ConstantProperty(weather?.descriptions)

    }
    
    init(city : City) {
        self.city = city
        
        nameProperty = ConstantProperty(String.notnilString(city.name))
        locationProperty = ConstantProperty(city.location)
        
        let weather = city.weather
        
        temperatureProperty = ConstantProperty(String.notnilString(weather?.temperature))
        pressureProperty = ConstantProperty(String.notnilString(weather?.pressure))
        humidityProperty = ConstantProperty(String.notnilString(weather?.humidity))
        windSpeedProperty = ConstantProperty(String.notnilString(weather?.windSpeed))
        descriptionsProperty = ConstantProperty(weather?.descriptions)
    }
}