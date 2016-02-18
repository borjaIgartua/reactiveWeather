//
//  AddCityRouting.swift
//  Weather
//
//  Created by Borja on 17/2/16.
//  Copyright © 2016 Borja. All rights reserved.
//

import UIKit

class AddCityRouting {
    
    class func presentAddCityModule(fromViewController viewController: UIViewController) {
        
        let view = AddCityViewController()
        let service = WeatherService()
        let viewModel = AddCityViewModel(weatherService: service)
        view.viewModel = viewModel
        
        viewController.presentViewController(view, animated: true, completion: nil)
    }
}