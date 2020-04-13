//
//  CustomMKCircle.swift
//  38HWMapKit
//
//  Created by Сергей on 08.04.2020.
//  Copyright © 2020 Sergei. All rights reserved.
//

import UIKit
import MapKit

class CustomMKCircle: MKCircle {

    var tag: Int?
    
    open func contains(location: CLLocation, outOfRadius: CLLocationDistance?) -> Bool {
        
        let outOfRadius = outOfRadius ?? 0
        
        let selfLocation = CLLocation(latitude: coordinate.latitude,
                                      longitude: coordinate.longitude)
        
        let distance = selfLocation.distance(from: location)
        
        guard radius > outOfRadius else {
            return false
        }
        
        let isConteins = outOfRadius...radius ~= distance ? true : false
        
        return isConteins
    }
    
    open func contains(locations: [CLLocation], outOfRadius: CLLocationDistance?) -> Int {
        
        let outOfRadius = outOfRadius ?? 0.0
        
        let selfLocation = CLLocation(latitude:  coordinate.latitude,
                                      longitude: coordinate.longitude)
        
        var countLocations = 0
        
        for location in locations {
            
            let distance = selfLocation.distance(from: location)
            
            if outOfRadius...self.radius ~= distance {
                countLocations += 1
            }
            
        }
        
        return countLocations
    }
    
    
}

extension CustomMKCircle {
    
    open func contains(students: [Student], outOfRadius: CLLocationDistance?) -> Int {
        
        let outOfRadius = outOfRadius ?? 0.0
        
        let selfLocation = CLLocation(latitude:  coordinate.latitude,
                                      longitude: coordinate.longitude)
        
        var countStudents = 0

        for stud in students {
            
            let studLocation = CLLocation(latitude:  stud.coordinate.latitude,
                                          longitude: stud.coordinate.longitude)
            
            let distance = selfLocation.distance(from: studLocation)
            
            if outOfRadius...self.radius ~= distance {
                countStudents += 1
            }
            
        }
        
        return countStudents
    }
    
    open func contains(student: Student, outOfRadius: CLLocationDistance?) -> Bool {
        
        var result = false
        
        let outOfRadius = outOfRadius ?? 0.0
        
        let selfLocation = CLLocation(latitude:  coordinate.latitude,
                                      longitude: coordinate.longitude)
            
            let studLocation = CLLocation(latitude:  student.coordinate.latitude,
                                          longitude: student.coordinate.longitude)
            
            let distance = selfLocation.distance(from: studLocation)
            
            if outOfRadius...self.radius ~= distance {
                result = true
            }
            
        return result
    }
    
}
