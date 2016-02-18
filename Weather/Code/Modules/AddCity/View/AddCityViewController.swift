//
//  AddCityViewController.swift
//  Weather
//
//  Created by Borja on 17/2/16.
//  Copyright © 2016 Borja. All rights reserved.
//

import UIKit
import ReactiveCocoa

class AddCityViewController : BIViewController {
    var viewModel : AddCityViewModel!
    
    let searchTexField = UITextField()
    let addCityView = AddCityView()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.searchText <~ searchTexField.rac_text
//        searchTexField.rac_enabled <~ viewModel.isSearching.producer.map { !$0 }
        addCityView.rac_alpha <~ viewModel.loadingAlpha.producer.map { $0 }
        
        viewModel.cityProperty.producer.startWithNext { (cityViewModel) -> () in
            self.addCityView.bindViewModel(withViewModel: cityViewModel)
        }
        
        addCityView.translatesAutoresizingMaskIntoConstraints = false
        addCityView.backgroundColor = UIColor.blueColor()
        self.view.addSubview(addCityView)
        
        searchTexField.translatesAutoresizingMaskIntoConstraints = false
        searchTexField.layer.cornerRadius = 5
        searchTexField.backgroundColor = UIColor.grayColor()
        self.view.addSubview(searchTexField)
        
        let views = ["searchTexField" : searchTexField, "addCityView" : addCityView]
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-12-[searchTexField]-12-|", views: views))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-44-[searchTexField(==34)]-(>=10)-|", views: views))
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[addCityView]|", views: views))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[addCityView]|", views: views))
        
    }
}