//
//  NSDateISO8601.swift
//  swift-todo-app
//
//  Created by Jógvan Olsen on 5/11/16.
//  Copyright © 2016 Mik Jensen. All rights reserved.
//

import Foundation

/*
    Javascript uses the ISO8601 standard: https://en.wikipedia.org/wiki/ISO_8601
    
    Got help from here
    https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSDateFormatter_Class/#//apple_ref/doc/uid/20000447-DontLinkElementID_2
    https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/Date/toISOString
 */

public extension NSDate{
    
    convenience init(iso8601: String){
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD'T'HH:mm:ss.SSSZ"
        self.init(timeIntervalSince1970: dateFormatter.dateFromString(iso8601)!.timeIntervalSince1970)
    }
    
    func toIsoString() -> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD'T'HH:mm:ss.SSS'Z'"
        return dateFormatter.stringFromDate(self)
    }
    
}