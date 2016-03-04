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
    let addButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.searchText <~ searchTexField.rac_text
//        searchTexField.rac_enabled <~ viewModel.isSearching.producer.map { !$0 }
        addCityView.rac_alpha <~ viewModel.loadingAlpha.producer.map { $0 }
        
        addButton.rac_signalForControlEvents(.TouchUpInside)
            .toSignalProducer()
            .map { (button) -> City? in
                return self.viewModel.currentCity
            }
            .startWithNext { (city) -> () in
                
                
            }

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
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.backgroundColor = UIColor.redColor()
        addButton.layer.cornerRadius = 30
        self.view.addSubview(addButton)
        
        let views = ["searchTexField" : searchTexField, "addCityView" : addCityView, "addButton" : addButton]
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-12-[searchTexField]-12-|", views: views))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-44-[searchTexField(==34)]-20-[addButton(==60)]-(>=10)-|", views: views))
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[addCityView]|", views: views))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[addCityView]|", views: views))
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[addButton(==60)]", views: views))
        self.view.addConstraint(NSLayoutConstraint.constraintCenterX(item: addButton, toItem: self.view))
        
    }
}