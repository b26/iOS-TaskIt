//
//  Date.swift
//  TaskIt
//
//  Created by Bashir on 2015-01-23.
//  Copyright (c) 2015 bashir. All rights reserved.
//

import Foundation

class Date {
    class func from(#year: Int, month: Int, day: Int) -> NSDate {
        var components = NSDateComponents()
        components.year = year
        components.month = month
        components.day = day
        
        var gregorianCalendar = NSCalendar(identifier: NSGregorianCalendar)
        var date = gregorianCalendar?.dateFromComponents(components)
        
        return date!
    }
    
    class func toString(#date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.stringFromDate(date)
        return dateString
    }
    
}