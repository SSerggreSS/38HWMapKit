//
//  ExtensionCLLocationCoordinate2D.swift
//  38HWMapKit
//
//  Created by Сергей on 01.04.2020.
//  Copyright © 2020 Sergei. All rights reserved.
//

import Foundation
import MapKit

extension CLLocationCoordinate2D {
    
    static var randomCoordinate: CLLocationCoordinate2D {
        
        let lantitude = Double.random(in: -90...90)
        let longitude = Double.random(in: -180...180)
        return CLLocationCoordinate2D(latitude: lantitude, longitude: longitude)
    }
    
    func randCoordIn(radius: CLLocationDistance) -> CLLocationCoordinate2D {
        
        var lawerValue = self.latitude - radius
        var upperValue = self.latitude + radius
        
        let latitude: Double = Double.random(in: lawerValue...upperValue)
        
        lawerValue = self.longitude - radius
        upperValue = self.longitude + radius
        
        let longitude: Double = Double.random(in: lawerValue...upperValue)
        
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    
    
}
