//
//  NSLayoutConstraints.swift
//  Weather
//
//  Created by Borja on 17/2/16.
//  Copyright © 2016 Borja. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    
    /* Create an array of constraints using an ASCII art-like visual format string with no format options.
    */
    public class func constraintsWithVisualFormat(_ format: String, views: [String : AnyObject]) -> [NSLayoutConstraint] {
        return NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
    }
    
    /* Create constraints explicitly. Center in X axis the view1 as the view2.
    */
    public class func constraintCenterX(item view1: AnyObject, toItem view2: AnyObject) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: view1, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: view2, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
    }
}
