//
//  AddCityViewModel.swift
//  Weather
//
//  Created by Borja on 17/2/16.
//  Copyright © 2016 Borja. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveSwift
import UIKit

class AddCityViewModel : BIViewModel {
    
    fileprivate let weatherService : WeatherService!
    fileprivate let session : Session? = LazyServiceLocator.sharedServiceLocator.getService()        
    
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
            .mapError({ _ in WeatherError.noError.toError() })
            .filter({ (text) -> Bool in
                return text.length > ReactiveConstants.SearchCharacterMinimum
            })
            .throttle(ReactiveConstants.SearchThrottleTime, on: QueueScheduler.main)
            .on(starting: {
                _ in self.isSearching.value = true
            })
            .flatMap(FlattenStrategy.latest, transform: { (text) -> SignalProducer<City?, NSError> in
                return self.weatherService.fetchCurrentWeather(forCity: text)
            })
            .observe(on: QueueScheduler.main)
            .startWithSignal { (signal, disposable) -> () in
                
                signal.observeResult({ (result) -> () in
                    
                    switch result {
                    case let .success(city):
                        
                        if let city = city {

                            self.currentCity = city
                            self.isSearching.value = false
                            self.cityProperty.value = CityViewModel(city: city)

                        } else {
                            //TODO: handle error
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
        
        loadingAlpha <~ isSearching.producer.map(enabledAlpha)
    }

    fileprivate func enabledAlpha(_ searching: Bool) -> CGFloat {
        return searching ? ReactiveConstants.DisabledViewAlpha : ReactiveConstants.EnabledViewAlpha
    }
    
    func addCity(_ city: City?) {
        session?.appendCity(city)
    }
}
