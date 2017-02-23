//
//  TableViewBindingHelper.swift
//  ReactiveSwiftFlickrSearch
//
//  Created by Colin Eberhardt on 15/07/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveSwift
import UIKit
import enum Result.NoError

// a helper that makes it easier to bind to UITableView instances
// see: http://www.scottlogic.com/blog/2014/05/11/reactivecocoa-tableview-binding.html
class TableViewBindingHelper<T: AnyObject> : NSObject {
    
    //MARK: Properties
    
    var delegate: UITableViewDelegate?
    
    fileprivate let tableView: UITableView
    fileprivate let templateCell: UITableViewCell
    
    fileprivate let dataSource: DataSource
    
    //MARK: Public API
    
    init(tableView: UITableView, sourceSignal: SignalProducer<[T], NoError>, cell: UITableViewCell, selectionCommand: Observer<AnyObject, NSError>? = nil, deletionCommand: Observer<AnyObject, NSError>? = nil) {
        self.tableView = tableView
        
        // create an instance of the template cell and register with the table view
        templateCell = cell
        tableView.register(cell.classForCoder.self, forCellReuseIdentifier: cell.reuseIdentifier!)
        
        dataSource = DataSource(data: [AnyObject](), templateCell: templateCell, selectionCommand:  selectionCommand, deletionCommand: deletionCommand)
        
        super.init()
    
        sourceSignal.startWithValues{ data in
            
            self.dataSource.data = data.map({ $0 as AnyObject })
            self.tableView.reloadData()
        }
        
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        
        tableView.estimatedRowHeight = 120.0
        tableView.rowHeight = UITableViewAutomaticDimension        
    }
}

class DataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    fileprivate let templateCell: UITableViewCell
    fileprivate let selectionCommand: Observer<AnyObject, NSError>?
    fileprivate let deletionCommand: Observer<AnyObject, NSError>?
    var data: [AnyObject]
    
    init(data: [AnyObject], templateCell: UITableViewCell, selectionCommand: Observer<AnyObject, NSError>? = nil, deletionCommand: Observer<AnyObject, NSError>? = nil) {
        self.data = data
        self.templateCell = templateCell
        self.selectionCommand = selectionCommand
        self.deletionCommand = deletionCommand
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item: AnyObject = data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: templateCell.reuseIdentifier!)!
        if let reactiveView = cell as? ReactiveView {
            reactiveView.bindViewModel(withViewModel: item)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {                
        if let deletionCommand = self.deletionCommand {
            deletionCommand.send(value: indexPath as AnyObject)
        }
        
        data.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let selectionCommand = self.selectionCommand {
            selectionCommand.send(value: indexPath as AnyObject)
        }
    }
    
}

