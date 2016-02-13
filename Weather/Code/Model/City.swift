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
    
}