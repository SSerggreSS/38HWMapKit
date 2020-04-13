//
//  ExtensionDate.swift
//  36HWPopover
//
//  Created by Сергей on 24.03.2020.
//  Copyright © 2020 Sergei. All rights reserved.
//

import Foundation


extension Date {
    
    static func randomDate(from: Int, before: Int) -> Date {
        
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        let randYear = Int.random(in: from...before)
        let randMonth = Int.random(in: 1...12)
        var randDay = 0
        let leapYear = randYear % 4 == 0 ? true : false
        let mothFebruare = randMonth == 2 ? true : false
        
        if randMonth % 2 != 0 {
            randDay = Int.random(in: 1...31)
        } else if randMonth % 2 == 0 && !mothFebruare {
            randDay = Int.random(in: 1...30)
        } else {
            randDay = leapYear ? Int.random(in: 1...29) : Int.random(in: 1...28)
        }
        components.year = randYear
        components.month = randMonth
        components.day = randDay
        
        let date = calendar.date(from: components) ?? Date(timeIntervalSince1970: 0)
        
        return date
    }
    
    func stringFromDateWithString(format: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let dateStr = dateFormatter.string(from: self)
        
        return dateStr
    }
    
}
