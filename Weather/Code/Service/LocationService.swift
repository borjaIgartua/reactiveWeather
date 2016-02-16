//
//  LocationService.swift
//  Weather
//
//  Created by Borja on 15/2/16.
//  Copyright © 2016 Borja. All rights reserved.
//

import Foundation
import ReactiveCocoa

class LocationService : NSObject, CLLocationManagerDelegate {
 
    private let locationManager = CLLocationManager()
    
    func updateLocationSignalProducer() -> SignalProducer<CLLocation?, NSError> {
    
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            locationManager.startUpdatingLocation()
        }
        
        return self.rac_signalForSelector("locationManager:didUpdateLocations:", fromProtocol: CLLocationManagerDelegate.self).toSignalProducer()
            .map({ (object) -> CLLocation in
                
                let tuple = object as! RACTuple
                return tuple.second.lastObject as! CLLocation
        })
        .mapError({ (error) -> NSError in
            return error
        })
    }
}