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
    
    fileprivate let weatherService : WeatherService!
    fileprivate let locationService : LocationService!
    fileprivate let session : Session? = LazyServiceLocator.sharedServiceLocator.getService()
    
    let isSearching = MutableProperty<Bool>(false)
    let loadingAlpha = MutableProperty<CGFloat>(ReactiveConstants.DisabledViewAlpha)
    let cities = MutableProperty<[CityViewModel]>([CityViewModel]())
    var deleteCommand : RACCommand?
    let deleteSignal : (Signal<AnyObject, NSError>, Observer<AnyObject, NSError>) = Signal.pipe()
    let selectSignal : (Signal<AnyObject, NSError>, Observer<AnyObject, NSError>) = Signal.pipe()
    var currentCity : CityViewModel?
    
    init(weatherService: WeatherService, locationService: LocationService) {
        self.weatherService = weatherService
        self.locationService = locationService
        super.init()
        
        locationService.updateLocationSignalProducer()
            .observeOn(UIScheduler())
            .flatMap(FlattenStrategy.Latest) { (location) -> SignalProducer<City?, NSError> in
                return self.weatherService.fetchCurrentWeather(forLocation: location)
        }
            .observeOn(QueueScheduler.mainQueueScheduler)
            .startWithSignal { (signal, disposable) -> () in
            
                signal.observeNext({ (city) -> () in
                    
                    if let city = city {
                        
                        self.currentCity = CityViewModel(city: city)
                        self.session?.appendCity(city)
                        self.cities.value.append(self.currentCity!)
                        
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
        
        self.deleteSignal.0.observeNext { (indexPath) -> () in
            
            let cityViewModel = self.cities.value[indexPath.row]
            if self.currentCity === cityViewModel {
                self.currentCity = nil
            }
            
            self.session?.removeCityAtIndex(indexPath.row)
        }
        
        self.selectSignal.0.observeNext { (indexPath) -> () in
//            if let cities = self.session?.cities {
//                let city = cities[indexPath.row]
//            }
        }
        
        loadingAlpha <~ isSearching.producer.map(enabledAlpha)
    }
    
    func reloadData() {
        
        if let cities = session?.cities {
            
            if cities.count > 0 {
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
        }
    }
    
    fileprivate func enabledAlpha(_ searching: Bool) -> CGFloat {
        return searching ? ReactiveConstants.DisabledViewAlpha : ReactiveConstants.EnabledViewAlpha
    }
}
