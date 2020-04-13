//
//  ExtensionBool.swift
//  38HWMapKit
//
//  Created by Сергей on 11.04.2020.
//  Copyright © 2020 Sergei. All rights reserved.
//

import Foundation

extension Bool {
    
    static public func makeArrayWith(countFalse: Int, countTrue: Int) -> [Bool] {
        
        let arrayFalse = Array(repeating: false, count: countFalse)
        let arrayTrue = Array(repeating: true, count: countTrue)
        let resultArray = arrayTrue + arrayFalse
        
        return resultArray
    }
    
}
