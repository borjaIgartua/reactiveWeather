//
//  CitiesViewController.swift
//  Weather
//
//  Created by Borja on 15/2/16.
//  Copyright © 2016 Borja. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

class CitiesViewController : BIViewController {
    var viewModel : CitiesViewModel!
    
    let tableView = UITableView()
    fileprivate var bindingHelper: TableViewBindingHelper<CityViewModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(CitiesViewController.addPressed))
        self.navigationItem.setRightBarButton(addButtonItem, animated: true)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        self.view.addSubview(tableView)
        self.bindingHelper = TableViewBindingHelper(tableView: self.tableView,
                                                    sourceSignal: self.viewModel.cities.producer,
                                                    cell: CityCell(style: .default, reuseIdentifier: "CityCell"),
                                                    selectionCommand: self.viewModel.selectSignal.1,
                                                    deletionCommand: self.viewModel.deleteSignal.1)
        
        let views = ["tableView" : tableView]
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[tableView]|", views: views))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[tableView]|", views: views))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        
        viewModel.reloadData()
    }
    
    func addPressed() {
        AddCityRouting.presentAddCityModule(fromViewController: self)
    }
}
