//
//  CitiesViewModel.swift
//  Weather
//
//  Created by Borja on 17/2/16.
//  Copyright © 2016 Borja. All rights reserved.
//

import Foundation
import ReactiveCocoa

class CitiesViewModel : BIViewModel  {
    
    private let weatherService : WeatherService!
    private let locationService : LocationService!
    private let session : Session? = LazyServiceLocator.sharedServiceLocator.getService()
    
    let isSearching = MutableProperty<Bool>(false)
    let loadingAlpha = MutableProperty<CGFloat>(ReactiveConstants.DisabledViewAlpha)
    let cities = MutableProperty<[CityViewModel]>([CityViewModel]())
    var currentCity : City?
    
    init(weatherService: WeatherService, locationService: LocationService) {
        self.weatherService = weatherService
        self.locationService = locationService
        super.init()
        
        if let cities = session?.cities {
            
            weatherService.fetchGroupWeather(forCities: cities)
                .mapError({ _ in WeatherError.NoError.toError() })
                .on(next: {
                _ in self.isSearching.value = true
            })
                .observeOn(QueueScheduler.mainQueueScheduler)
                .startWithSignal { (signal, disposable) -> () in
                    
                    signal.observeNext({ (cities) -> () in
                        
                        if let cities = cities {
                            self.cities.value = cities.map { CityViewModel(city: $0) }
                            
                            if let city = self.currentCity {
                                self.cities.value.append(CityViewModel(city: city))
                            }
                
                        } else {
                            //TODO: handle error
                        }
                    })
                    signal.observeFailed({ (error) -> () in
                        disposable.dispose()
                        print(error)
                    })
            }
        }
        
        locationService.updateLocationSignalProducer()
            .observeOn(UIScheduler())
            .flatMap(FlattenStrategy.Latest) { (location) -> SignalProducer<City?, NSError> in
                return self.weatherService.fetchCurrentWeather(forLocation: location)
        }
            .observeOn(QueueScheduler.mainQueueScheduler)
            .startWithSignal { (signal, disposable) -> () in
            
                signal.observeNext({ (city) -> () in
                    
                    if let city = city {
                        
                        if (self.cities.value.count == 0) {
                            self.currentCity = city
                            
                        } else {
                            self.cities.value.append(CityViewModel(city: city))
                        }
                        
                        self.isSearching.value = false
                        disposable.dispose()
                        
                    } else {
                        //TODO: handle error
                    }
                })
                signal.observeFailed({ (error) -> () in
                    disposable.dispose()
                    print(error)
                })
        }
        
        loadingAlpha <~ isSearching.producer.map(enabledAlpha)
    }
    
    private func enabledAlpha(searching: Bool) -> CGFloat {
        return searching ? ReactiveConstants.DisabledViewAlpha : ReactiveConstants.EnabledViewAlpha
    }
}