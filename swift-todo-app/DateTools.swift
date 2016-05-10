//
//  DateTools.swift
//  swift-todo-app
//
//  Created by Jógvan Olsen on 5/10/16.
//  Copyright © 2016 Mik Jensen. All rights reserved.
//

import UIKit

class DateTools: NSObject {
    
    /*
        Got help from here (ps. I hate coding with time)
        https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSDateFormatter_Class/#//apple_ref/doc/uid/20000447-DontLinkElementID_2
        https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/Date/toISOString
     */
    static func dateFromISO(isoString: String) -> NSDate{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD'T'HH:mm:ss.SSSZ"
        return dateFormatter.dateFromString(isoString)!
    }
    
}
