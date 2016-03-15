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
                            self.cities.value = cities.map { CityViewModel(city: $0) } //look id the cities value have the citiy location, should not delete!
                            
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
            .startWithSignal { (signal, disposable) -> () in
            
                signal.observe { event in
                    
                switch event {
                    case .Next:
//                        cities.value.append(event.value.map{ CityViewModel(city: $0) }) hay que coger la localización, hacer el flattern map con la señal para pedir el tiempo por localizacion igual que con las busquedas y de ahí coger la ciudad
                        disposable.dispose()
                    case .Failed, .Completed:
                        disposable.dispose()
                    default:
                        break
                    }
                }
        }
    }
    
    private func enabledAlpha(searching: Bool) -> CGFloat {
        return searching ? ReactiveConstants.DisabledViewAlpha : ReactiveConstants.EnabledViewAlpha
    }
}