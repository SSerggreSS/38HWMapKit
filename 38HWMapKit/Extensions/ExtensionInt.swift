//
//  ExtensionInt.swift
//  30HWTableView
//
//  Created by Сергей on 01.02.2020.
//  Copyright © 2020 Sergei. All rights reserved.
//

import Foundation

extension Int {
    
    static func randomNotRepeatNumber(in range: ClosedRange<Int>) -> [Int] {
        
        var randomNumbers = [Int]()
        var randomNumber = Int.random(in: range)
        let rangeMin = range.min() ?? 0
        let rangeMax = range.max() ?? 0
        var validSet = Set<Int>()
        
        while randomNumbers.count != ((rangeMax + 1) - rangeMin) {
            
            if !validSet.contains(randomNumber) {
                validSet.insert(randomNumber)
                randomNumbers.append(randomNumber)
            }
            
            randomNumber = Int.random(in: range)
        }
        
        return randomNumbers
    }
    
}


