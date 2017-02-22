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
    
    func appendCity(_ city: City?) {
        
        if let city = city {
            
            if self.cities != nil {
                self.cities!.append(city)
                
            } else {
                
                var newCities = [City]()
                newCities.append(city)
                cities = newCities
            }
        }
    }
    
    func removeCityAtIndex(_ index : Int) {        
        self.cities?.remove(at: index)
    }
    
    func saveLoadedData() {
        self.archiveData(withObject: self.cities as AnyObject?, forKey: kSessionCitiesKey)
    }
    
    fileprivate func loadStorageData() {
        self.cities = self.unarchiveDataForKey(kSessionCitiesKey) as? [City]
    }
    
    fileprivate func archiveData(withObject object: AnyObject?, forKey key: String) {
        
        if let object = object {
            let data = NSKeyedArchiver.archivedData(withRootObject: object)
            UserDefaults.standard.set(data, forKey: key)
            UserDefaults.standard.synchronize()
        }
    }
    
    fileprivate func unarchiveDataForKey(_ key: String) -> AnyObject? {
        
        if let data = UserDefaults.standard.object(forKey: key) as? Data {
            return NSKeyedUnarchiver.unarchiveObject(with: data) as AnyObject?
        }
        return nil
    }
}
