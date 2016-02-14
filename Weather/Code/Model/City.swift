//
//  City.swift
//  Weather
//
//  Created by Borja on 13/2/16.
//  Copyright © 2016 Borja. All rights reserved.
//

import Foundation
import CoreLocation

struct City {
    
    var id : String
    var location : CLLocation?
    var name : String
    var weather : Weather?
    
    init(withID id: String, location: CLLocation?, name: String, weather: Weather?) {
        
        self.id = id
        self.location = location
        self.name = name
        self.weather = weather
    }
    
    init(responseData: JSON) {
        
        self.id = responseData["id"].stringValue
        self.name = responseData["name"].stringValue

        let cityCoordData = responseData["coord"].dictionaryValue
        let latitude = cityCoordData["lat"]?.doubleValue
        let longitude = cityCoordData["lon"]?.doubleValue
        
        if let latitude = latitude {
            if let longitude = longitude {
                self.location = CLLocation(latitude: latitude, longitude: longitude)
            }
        }
        
        self.weather = Weather(responseData: responseData)
    }
    
}