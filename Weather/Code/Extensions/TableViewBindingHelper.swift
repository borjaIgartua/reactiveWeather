//
//  TableViewBindingHelper.swift
//  ReactiveSwiftFlickrSearch
//
//  Created by Colin Eberhardt on 15/07/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation
import ReactiveCocoa
import UIKit
import enum Result.NoError

// a helper that makes it easier to bind to UITableView instances
// see: http://www.scottlogic.com/blog/2014/05/11/reactivecocoa-tableview-binding.html
class TableViewBindingHelper<T: AnyObject> : NSObject {
    
    //MARK: Properties
    
    var delegate: UITableViewDelegate?
    
    private let tableView: UITableView
    private let templateCell: UITableViewCell
    
    private let dataSource: DataSource
    
    //MARK: Public API
    
    init(tableView: UITableView, sourceSignal: SignalProducer<[T], NoError>, cell: UITableViewCell, selectionCommand: Observer<AnyObject, NSError>? = nil, deletionCommand: Observer<AnyObject, NSError>? = nil) {
        self.tableView = tableView
        
        // create an instance of the template cell and register with the table view
        templateCell = cell
        tableView.registerClass(cell.classForCoder.self, forCellReuseIdentifier: cell.reuseIdentifier!)
        
        dataSource = DataSource(data: [AnyObject](), templateCell: templateCell, selectionCommand:  selectionCommand, deletionCommand: deletionCommand)
        
        super.init()
    
        sourceSignal.startWithNext{ data in
            
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
    
    private let templateCell: UITableViewCell
    private let selectionCommand: Observer<AnyObject, NSError>?
    private let deletionCommand: Observer<AnyObject, NSError>?
    var data: [AnyObject]
    
    init(data: [AnyObject], templateCell: UITableViewCell, selectionCommand: Observer<AnyObject, NSError>? = nil, deletionCommand: Observer<AnyObject, NSError>? = nil) {
        self.data = data
        self.templateCell = templateCell
        self.selectionCommand = selectionCommand
        self.deletionCommand = deletionCommand
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let item: AnyObject = data[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(templateCell.reuseIdentifier!)!
        if let reactiveView = cell as? ReactiveView {
            reactiveView.bindViewModel(withViewModel: item)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {                
        if let deletionCommand = self.deletionCommand {
            deletionCommand.sendNext(indexPath)
        }
        
        data.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let selectionCommand = self.selectionCommand {
            selectionCommand.sendNext(indexPath)
        }
    }
    
}
