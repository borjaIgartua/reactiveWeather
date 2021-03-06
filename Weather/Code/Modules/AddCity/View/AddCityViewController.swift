//
//  AddCityViewController.swift
//  Weather
//
//  Created by Borja on 17/2/16.
//  Copyright © 2016 Borja. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

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
        
        let producer = SignalProducer(addButton.reactive.controlEvents(UIControlEvents.touchUpInside))

        producer.map { (button) -> City? in
            return self.viewModel.currentCity
            
        }.startWithValues { (city) in
            self.viewModel.addCity(city)
            self .dismiss(animated: true, completion: nil)
        }
        

        viewModel.cityProperty.producer.startWithValues { (cityViewModel) -> () in
            self.addCityView.bindViewModel(withViewModel: cityViewModel)
        }
        
        addCityView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(addCityView)
        
        searchTexField.translatesAutoresizingMaskIntoConstraints = false
        searchTexField.layer.cornerRadius = 5
        searchTexField.backgroundColor = UIColor.gray
        self.view.addSubview(searchTexField)
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setImage( UIImage(named: "PlusCircle.png"), for: UIControlState())
        self.view.addSubview(addButton)
        
        let views : [String : AnyObject] = ["searchTexField" : searchTexField, "addCityView" : addCityView, "addButton" : addButton]
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-12-[searchTexField]-12-|", views: views))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-44-[searchTexField(==34)]-20-[addButton(==60)]-(>=10)-|", views: views))
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[addCityView]|", views: views))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[addCityView]|", views: views))
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[addButton(==60)]", views: views))
        self.view.addConstraint(NSLayoutConstraint.constraintCenterX(item: addButton, toItem: self.view))
        
    }
}
