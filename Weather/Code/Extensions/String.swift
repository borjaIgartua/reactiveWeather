//
//  String.swift
//  Weather
//
//  Created by Borja on 17/2/16.
//  Copyright © 2016 Borja. All rights reserved.
//

import Foundation

extension String {
    
    public var length : Int {
        get {
            return self.characters.count
        }
    }
    
    public var encodedQueryURL : String? {
        get {
            return self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        }
    }
    
    static func notnilString(string : String?) -> String {
        
        if let string = string {
            return string
        } else {
            return ""
        }
    }
    
    static func notnilString(double : Double?) -> String {
        
        if let double = double {
            return String(format: "%.2f", double)
        } else {
            return ""
        }
    }
}