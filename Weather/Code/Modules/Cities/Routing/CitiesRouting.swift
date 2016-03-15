//
//  CitiesRouting.swift
//  Weather
//
//  Created by Borja on 15/2/16.
//  Copyright © 2016 Borja. All rights reserved.
//

import UIKit

class CitiesRouting  {
    
    class func presentCitiesModule(inWindow window: UIWindow) {
        
        let view = CitiesViewController()
        let weatherService = WeatherService()
        let locationService = LocationService()
        let viewModel = CitiesViewModel(weatherService: weatherService, locationService: locationService)
        view.viewModel = viewModel
        
        let navigationController = UINavigationController(rootViewController: view)
        navigationController.navigationBar.translucent = false

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}