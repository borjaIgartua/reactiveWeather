//
//  CitiesViewController.swift
//  Weather
//
//  Created by Borja on 15/2/16.
//  Copyright © 2016 Borja. All rights reserved.
//

import UIKit
import ReactiveCocoa

class CitiesViewController : BIViewController {
    var viewModel : CitiesViewModel!
    
    let tableView = UITableView()
    private var bindingHelper: TableViewBindingHelper<CityViewModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addPressed")
        self.navigationItem.setRightBarButtonItem(addButtonItem, animated: true)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        self.bindingHelper = TableViewBindingHelper(tableView: self.tableView, sourceSignal: self.viewModel.cities.producer, cell: CityCell(style: .Default, reuseIdentifier: "CityCell"))
        
        let views = ["tableView" : tableView]
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[tableView]|", views: views))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[tableView]|", views: views))
        
    }
    
    func addPressed() {
        AddCityRouting.presentAddCityModule(fromViewController: self)
    }
}