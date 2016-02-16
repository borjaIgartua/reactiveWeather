//
//  CitiesPresenter.swift
//  Weather
//
//  Created by Borja on 15/2/16.
//  Copyright © 2016 Borja. All rights reserved.
//

import Foundation
import CoreLocation
import ReactiveCocoa

class CitiesPresenter : NSObject, BIPresenterClient, CLLocationManagerDelegate {
    
    let routing : CitiesRouting!
    let locationService = LocationService()
    
    init(routing : CitiesRouting) {
        self.routing = routing
    }
    
//MARK: presenter Client
    
    func viewDidLoad() {
        
        locationService.updateLocationSignalProducer()
            .startWithSignal { signal, disposable in

                signal.observe { event in
                    switch event {
                    case .Next:
                        print("Next event received: \(event.value)")
                    case .Failed:
                        //TODO: show eror
                        print("event failed: \(event.error)")
                        disposable.dispose()
                    case .Completed:
                        print("Completed, value: \(event.value)")
                        disposable.dispose()
                    default:
                        break
                    }
                }
        }

    }

}