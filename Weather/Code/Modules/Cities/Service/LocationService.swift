//
//  LocationService.swift
//  Weather
//
//  Created by Borja on 15/2/16.
//  Copyright © 2016 Borja. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveSwift
import CoreLocation
import enum Result.NoError

class LocationService : NSObject, CLLocationManagerDelegate {
    let signal : Signal<[CLLocation], NoError>
    let observer : Observer<[CLLocation], NoError>
    
    private let locationManager = CLLocationManager()
    
    override init() {
        let pipe = Signal<[CLLocation], NoError>.pipe()
        self.signal = pipe.output
        self.observer = pipe.input
    }
    
    func updateLocationSignalProducer() -> SignalProducer<[CLLocation], NoError> {
    
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            locationManager.startUpdatingLocation()
        }
        
        return SignalProducer(self.signal)
        
//        return SignalProducer(self.reactive.trigger(for: #selector(CLLocationManagerDelegate.locationManager(_:didUpdateLocations:)))).map { (object) -> CLLocation in
//            
//            return CLLocation()
//        }.mapError { (error) -> NSError in
//            
//            return NSError()
//        }
        
        
//        return self.rac_signalForSelector(#selector(CLLocationManagerDelegate.locationManager(_:didUpdateLocations:)), fromProtocol: CLLocationManagerDelegate.self).toSignalProducer()
//            .map({ (object) -> CLLocation in
//                
//                let tuple = object as! RACTuple
//                return tuple.second.lastObject as! CLLocation
//        })
//        .mapError({ (error) -> NSError in
//            return error
//        })
    }
    
}

extension LocationService {
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.observer.send(value: locations)
    }
//    typealias Locations = [CLLocation]
//    
//    // Signal
//    var signalDidScrollToIndex: Signal<Locations, NoError> {
//        delegate = LocationService.delegateProxy
//        return delegateProxy.signal
//    }
//    
//    private static let delegateProxy = LocationServiceProxy(pipe: Signal<Locations, NoError>.pipe() as! (signal: Signal<LocationService.Locations, NoError>, observer: Observer<LocationService.Locations, NoError>))
//    
//    private class LocationServiceProxy : CLLocationManagerDelegate {
//        let signal : Signal<Locations, NoError>
//        let observer : Observer<Locations, NoError>
//        
//        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//            observer.send(value: locations)
//        }
//        
//        init(pipe: (signal: Signal<Locations, NoError>, observer: Observer<Locations, NoError>)) {
//            signal = pipe.signal
//            observer = pipe.observer
//        }
//    }
}
