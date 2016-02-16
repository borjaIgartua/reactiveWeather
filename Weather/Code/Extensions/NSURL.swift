//
//  NSURLExtension.swift
//  Weather
//
//  Created by Borja on 13/2/16.
//  Copyright © 2016 Borja. All rights reserved.
//

import Foundation

extension NSURL {
    
    public convenience init?(string URLString: String, parameters: [(String, String)]) {
        
        var newAbsoluteString = URLString
        var addFirstParameter = false
        
        if !newAbsoluteString.containsString("?") {
            
            addFirstParameter = true
        }
        
        for parameter in parameters {
            
            if addFirstParameter {
                newAbsoluteString = newAbsoluteString + "?" + parameter.0 + "=" + parameter.1
                addFirstParameter = false
                
            } else {
                newAbsoluteString = newAbsoluteString + "&" + parameter.0 + "=" + parameter.1
            }
        }
        
        self.init(string: newAbsoluteString)
        
    }
}