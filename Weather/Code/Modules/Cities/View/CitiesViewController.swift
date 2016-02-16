//
//  CitiesViewController.swift
//  Weather
//
//  Created by Borja on 15/2/16.
//  Copyright © 2016 Borja. All rights reserved.
//

import UIKit

class CitiesViewController : BIViewController, BIViewClient {
    
    override func viewDidLoad() {
        self.presenter.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
    }
}