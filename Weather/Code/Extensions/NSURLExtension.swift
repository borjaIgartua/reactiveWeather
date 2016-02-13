//
//  NSURLExtension.swift
//  Weather
//
//  Created by Borja on 13/2/16.
//  Copyright © 2016 Borja. All rights reserved.
//

import Foundation

extension NSURL {
    
    func addParameters(paramenters: [(String, String)]) -> NSURL? {
        
        var newAbsoluteString = self.absoluteString
        var addFirstParameter = false
        
        if !newAbsoluteString.containsString("?") {
            
            addFirstParameter = true
        }
        
        for parameter in paramenters {
            
            if addFirstParameter {
                newAbsoluteString = newAbsoluteString + "?" + parameter.0 + "=" + parameter.1
                addFirstParameter = false
                
            } else {
                newAbsoluteString = newAbsoluteString + "&" + parameter.0 + "=" + parameter.1
            }
        }
        
        return NSURL(string: newAbsoluteString)
    }
}