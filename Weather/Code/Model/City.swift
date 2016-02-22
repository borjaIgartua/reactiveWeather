//
//  City.swift
//  Weather
//
//  Created by Borja on 13/2/16.
//  Copyright © 2016 Borja. All rights reserved.
//

import Foundation
import CoreLocation

public class City : NSObject, NSCoding {
    
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
    
    public func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(self.name, forKey: "CityNameKey")
        aCoder.encodeObject(self.id, forKey: "CityIDkey")

        let latitude : Double? = self.location?.coordinate.latitude
        if let latitude = latitude {
            aCoder.encodeDouble(latitude, forKey: "CityLatitudeKey")
        }
        
        let longitude : Double? = self.location?.coordinate.longitude
        if let longitude = longitude {
            aCoder.encodeDouble(longitude, forKey: "CityLongitudeKey")
        }
    }
    
    required public init(coder aDecoder: NSCoder) {
        
        self.id = aDecoder.decodeObjectForKey("CityIDkey") as! String
        self.name = aDecoder.decodeObjectForKey("CityNameKey") as? String
        
        let latitude : Double? = aDecoder.decodeDoubleForKey("CityLatitudeKey")
        let longitude : Double? = aDecoder.decodeDoubleForKey("CityLongitudeKey")
        
        if let latitude = latitude  {
            if let longitude = longitude {
                if (latitude != 0 || longitude != 0) {
                    self.location = CLLocation(latitude: latitude, longitude: longitude)
                }
            }
        }
    }
    
    
}