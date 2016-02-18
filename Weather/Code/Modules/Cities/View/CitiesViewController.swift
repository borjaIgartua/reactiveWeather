//
//  CitiesViewController.swift
//  Weather
//
//  Created by Borja on 15/2/16.
//  Copyright © 2016 Borja. All rights reserved.
//

import UIKit

class CitiesViewController : BIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addPressed")
        self.navigationItem.setRightBarButtonItem(addButtonItem, animated: true)
    }
    
    func addPressed() {
        AddCityRouting.presentAddCityModule(fromViewController: self)
    }
}