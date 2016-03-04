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
    
    private struct Constants {
        static let SearchCharacterMinimum = 3
        static let SearchThrottleTime = 2.5
        static let DisabledViewAlpha: CGFloat = 0.5
        static let EnabledViewAlpha: CGFloat = 1.0
    }
    
    let searchText = MutableProperty<String>("")
    let queryExecutionTime = MutableProperty<String>("")
    let isSearching = MutableProperty<Bool>(false)
    let cityProperty = MutableProperty<CityViewModel>(CityViewModel())
    let loadingAlpha = MutableProperty<CGFloat>(Constants.DisabledViewAlpha)
    
    var currentCity : City?

    
    init(weatherService: WeatherService) {        
        self.weatherService = weatherService
        super.init()
                
        searchText.producer
            .mapError({ _ in WeatherError.NoError.toError() })
            .filter({ (text) -> Bool in
                return text.length > Constants.SearchCharacterMinimum
            })
            .throttle(Constants.SearchThrottleTime, onScheduler: QueueScheduler.mainQueueScheduler)
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
                    print(error)
                })
            }
        
        loadingAlpha <~ isSearching.producer.map(enabledAlpha)
    }

    private func enabledAlpha(searching: Bool) -> CGFloat {
        return searching ? Constants.DisabledViewAlpha : Constants.EnabledViewAlpha
    }
}