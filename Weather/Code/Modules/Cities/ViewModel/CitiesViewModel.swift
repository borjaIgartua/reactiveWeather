//
//  CitiesViewModel.swift
//  Weather
//
//  Created by Borja on 17/2/16.
//  Copyright © 2016 Borja. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveSwift
import UIKit
import enum Result.NoError
import Result

class CitiesViewModel : BIViewModel  {
    
    fileprivate let weatherService : WeatherService!
    fileprivate let locationService : LocationService!
    fileprivate let session : Session? = LazyServiceLocator.sharedServiceLocator.getService()
    
    let isSearching = MutableProperty<Bool>(false)
    let loadingAlpha = MutableProperty<CGFloat>(ReactiveConstants.DisabledViewAlpha)
    let cities = MutableProperty<[CityViewModel]>([CityViewModel]())
    let deleteSignal : (Signal<AnyObject, NSError>, Observer<AnyObject, NSError>) = Signal.pipe()
    let selectSignal : (Signal<AnyObject, NSError>, Observer<AnyObject, NSError>) = Signal.pipe()
    var currentCity : CityViewModel?
    
    init(weatherService: WeatherService, locationService: LocationService) {
        self.weatherService = weatherService
        self.locationService = locationService
        super.init()
        
        
        locationService.updateLocationSignalProducer()
            .flatMap(FlattenStrategy.latest) { (locations) -> SignalProducer<City?, NSError> in
                return self.weatherService.fetchCurrentWeather(forLocation: locations[0])
        }
            .observe(on: QueueScheduler.main)
            .startWithSignal { (signal, disposable) -> () in
                
                signal.observeResult({ (result) in
                    
                    switch result {
                    case let .success(city):
                        
                        if let city = city {
                            self.currentCity = CityViewModel(city: city)
                            self.session?.appendCity(city)
                            self.cities.value.append(self.currentCity!)
                            
                            self.isSearching.value = false
                            disposable.dispose()
                        }
                        
                        
                        break
                    case let .failure(error):
                        print("Error received returning City: " + error.localizedDescription)
                        break
                    }
                    
                })
                
                
                signal.observeFailed({ (error) -> () in
                    disposable.dispose()
                    print(error)
                })
        }
        
        
        self.deleteSignal.0.observeResult { (result) -> () in
            
            switch result {
            case let .success(indexPath):
                
            let cityViewModel = self.cities.value[indexPath.row]
            if self.currentCity === cityViewModel {
                self.currentCity = nil
            }

            self.session?.removeCityAtIndex(indexPath.row)
            
                
                break
            case let .failure(error):
                print("Error received returning City: " + error.localizedDescription)
                break
            }

        }
        
        self.selectSignal.0.observeResult { (indexPath) -> () in
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
                    .mapError({ _ in WeatherError.noError.toError() })
                    .on(starting: {
                        _ in self.isSearching.value = true
                    })
                    .observe(on: QueueScheduler.main)
                    .startWithSignal { (signal, disposable) -> () in
                        
                        signal.observeResult({ (result) -> () in
                           
                            switch result {
                            case let .success(cities):
                                
                                if let cities = cities {
                                    self.cities.value = cities.map { CityViewModel(city: $0) }
                                }
    
                                break
                            case let .failure(error):
                                print("Error reloading cities data: " + error.localizedDescription)
                                break
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
