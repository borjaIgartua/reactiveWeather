//
//  CLLocation.swift
//  Weather
//
//  Created by Borja on 16/3/16.
//  Copyright © 2016 Borja. All rights reserved.
//

import Foundation
import CoreLocation

extension CLLocation {
    
    //return string tupla (latitude, longitude)
    public var encodedQueryURL : (String,String) {
        get {
            let latitudeString = String(format:"%f", self.coordinate.latitude)
            let longitudeString = String(format:"%f", self.coordinate.longitude)
            return (latitudeString, longitudeString)
        }
    }
}