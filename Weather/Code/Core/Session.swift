//
//  Session.swift
//  Weather
//
//  Created by Borja on 22/2/16.
//  Copyright © 2016 Borja. All rights reserved.
//

import Foundation

let kSessionCitiesKey = "kSessionCitiesKey"

class Session {
    
    var cities : [City]?
    
    init() {
        self.loadStorageData()
    }
    
    func addOneModeCity(city: City) {
        
        if self.cities != nil {
            self.cities!.append(city)
            
        } else {
            
            var newCities = [City]()
            newCities.append(city)
            cities = newCities
        }
    }
    
    func saveLoadedData() {
        self.archiveData(withObject: self.cities, forKey: kSessionCitiesKey)
    }
    
    private func loadStorageData() {
        self.cities = self.unarchiveDataForKey(kSessionCitiesKey) as? [City]
    }
    
    private func archiveData(withObject object: AnyObject?, forKey key: String) {
        
        if let object = object {
            let data = NSKeyedArchiver.archivedDataWithRootObject(object)
            NSUserDefaults.standardUserDefaults().setObject(data, forKey: key)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    private func unarchiveDataForKey(key: String) -> AnyObject? {
        
        if let data = NSUserDefaults.standardUserDefaults().objectForKey(key) as? NSData {
            return NSKeyedUnarchiver.unarchiveObjectWithData(data)
        }
        return nil
    }
}