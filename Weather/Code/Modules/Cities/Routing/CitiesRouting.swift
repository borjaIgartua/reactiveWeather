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
    
//        let routing = CitiesRouting()
        let view = CitiesViewController()
    
        
        let navigationController = UINavigationController(rootViewController: view)
        navigationController.navigationBar.translucent = false

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}