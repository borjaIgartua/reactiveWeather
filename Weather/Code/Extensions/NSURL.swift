//
//  NSURLExtension.swift
//  Weather
//
//  Created by Borja on 13/2/16.
//  Copyright © 2016 Borja. All rights reserved.
//

import Foundation

extension URL {
    
    public init?(string URLString: String, parameters: [(String, String?)]) {
        
        var newAbsoluteString = URLString
        var addFirstParameter = false
        
        if !newAbsoluteString.contains("?") {
            
            addFirstParameter = true
        }
        
        for parameter in parameters {
            
            if addFirstParameter {
                
                if let value = parameter.1 {
                    newAbsoluteString = newAbsoluteString + "?" + parameter.0 + "=" + value
                    addFirstParameter = false
                }
                
            } else {
                
                if let value = parameter.1 {
                    newAbsoluteString = newAbsoluteString + "&" + parameter.0 + "=" + value
                }
            }
        }
        
        (self as NSURL).init(string: newAbsoluteString)        
    }
}
