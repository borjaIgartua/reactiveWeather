//
//  City.swift
//  Weather
//
//  Created by Borja on 13/2/16.
//  Copyright © 2016 Borja. All rights reserved.
//

import Foundation
import CoreLocation

open class City : NSObject, NSCoding {
    
    var id : String
    var location : CLLocation?
    var name : String?
    var weather : Weather?
    
    override init() {
        
        self.id = ""
        self.location = nil
        self.name = nil
        self.weather = nil
    }
    
    init(withID id: String, location: CLLocation?, name: String?, weather: Weather?) {
        
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
    
//MARK: Coding methods
    
    open func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.name, forKey: "CityNameKey")
        aCoder.encode(self.id, forKey: "CityIDkey")

        let latitude : Double? = self.location?.coordinate.latitude
        if let latitude = latitude {
            aCoder.encode(latitude, forKey: "CityLatitudeKey")
        }
        
        let longitude : Double? = self.location?.coordinate.longitude
        if let longitude = longitude {
            aCoder.encode(longitude, forKey: "CityLongitudeKey")
        }
    }
    
    required public init(coder aDecoder: NSCoder) {
        
        self.id = aDecoder.decodeObject(forKey: "CityIDkey") as! String
        self.name = aDecoder.decodeObject(forKey: "CityNameKey") as? String
        
        let latitude : Double? = aDecoder.decodeDouble(forKey: "CityLatitudeKey")
        let longitude : Double? = aDecoder.decodeDouble(forKey: "CityLongitudeKey")
        
        if let latitude = latitude  {
            if let longitude = longitude {
                if (latitude != 0 || longitude != 0) {
                    self.location = CLLocation(latitude: latitude, longitude: longitude)
                }
            }
        }
    }
    
    
}
