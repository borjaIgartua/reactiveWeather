//
//  CityViewModel.swift
//  Weather
//
//  Created by Borja on 18/2/16.
//  Copyright © 2016 Borja. All rights reserved.
//

import Foundation
import ReactiveSwift
import CoreLocation

class CityViewModel {
    
    let nameProperty : Property<String>
    let locationProperty : Property<CLLocation?>

    let temperatureProperty : Property<String>
    let pressureProperty : Property<String>
    let humidityProperty : Property<String>
    let windSpeedProperty : Property<String>
    let descriptionsProperty : Property<[WeatherDescription]?>
    
    fileprivate let city : City
    
    init() {
        
        self.city = City()
        
        nameProperty = Property(value: String.notnilString(city.name))
        locationProperty = Property(value:city.location)

        let weather = city.weather
        
        temperatureProperty = Property(value: String.notnilString(weather?.temperature))
        pressureProperty = Property(value: String.notnilString(weather?.pressure))
        humidityProperty = Property(value: String.notnilString(weather?.humidity))
        windSpeedProperty = Property(value: String.notnilString(weather?.windSpeed))
        descriptionsProperty = Property(value: weather?.descriptions)

    }
    
    init(city : City) {
        self.city = city
        
        nameProperty = Property(value:String.notnilString(city.name))
        locationProperty = Property(value:city.location)
        
        let weather = city.weather
        
        temperatureProperty = Property(value: String.notnilString(weather?.temperature))
        pressureProperty = Property(value: String.notnilString(weather?.pressure))
        humidityProperty = Property(value: String.notnilString(weather?.humidity))
        windSpeedProperty = Property(value: String.notnilString(weather?.windSpeed))
        descriptionsProperty = Property(value: weather?.descriptions)
    }
}
