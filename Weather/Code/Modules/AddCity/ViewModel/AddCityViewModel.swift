//
//  AddCityViewModel.swift
//  Weather
//
//  Created by Borja on 17/2/16.
//  Copyright © 2016 Borja. All rights reserved.
//

import Foundation
import ReactiveCocoa

class AddCityViewModel : BIViewModel {
    
    private let weatherService : WeatherService!
    private let session : Session? = LazyServiceLocator.sharedServiceLocator.getService()        
    
    let searchText = MutableProperty<String>("")
    let queryExecutionTime = MutableProperty<String>("")
    let isSearching = MutableProperty<Bool>(false)
    let cityProperty = MutableProperty<CityViewModel>(CityViewModel())
    let loadingAlpha = MutableProperty<CGFloat>(ReactiveConstants.DisabledViewAlpha)
    
    var currentCity : City?

    
    init(weatherService: WeatherService) {        
        self.weatherService = weatherService
        super.init()
                
        searchText.producer
            .mapError({ _ in WeatherError.NoError.toError() })
            .filter({ (text) -> Bool in
                return text.length > ReactiveConstants.SearchCharacterMinimum
            })
            .throttle(ReactiveConstants.SearchThrottleTime, onScheduler: QueueScheduler.mainQueueScheduler)
            .on(next: {
                _ in self.isSearching.value = true
            })
            .flatMap(FlattenStrategy.Latest, transform: { (text) -> SignalProducer<City?, NSError> in
                return self.weatherService.fetchCurrentWeather(forCity: text)
            })
            .observeOn(QueueScheduler.mainQueueScheduler)
            .startWithSignal { (signal, disposable) -> () in
                
                signal.observeNext({ (city) -> () in
                    
                    if let city = city {
                        
                        self.currentCity = city
                        self.isSearching.value = false
                        self.cityProperty.value = CityViewModel(city: city)
                        
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
    
    func addCity(city: City?) {
        session?.appendCity(city)
    }
}