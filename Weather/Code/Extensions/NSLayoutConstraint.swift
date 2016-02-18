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
    public class func constraintsWithVisualFormat(format: String, views: [String : AnyObject]) -> [NSLayoutConstraint] {
        return NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
    }
    
    /* Create constraints explicitly. Center in X axis the view1 as the view2.
    */
    public class func constraintCenterX(item view1: AnyObject, toItem view2: AnyObject) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: view1, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view2, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
    }
}