//
//  PlaceMeet.swift
//  38HWMapKit
//
//  Created by Сергей on 05.04.2020.
//  Copyright © 2020 Sergei. All rights reserved.
//

import Foundation
import MapKit

//этот класс позволяет определять аннотацию и вид аннотации для места на карте

class PlaceMeet: MKAnnotationView, MKAnnotation {
    
    var smallCircle: CustomMKCircle
    var middleCircle: CustomMKCircle
    var largeCircle: CustomMKCircle
    
    //MARK: MKAnnotation implementation protocol
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        self.coordinate = CLLocationCoordinate2D(latitude: latitude,
                                                 longitude: longitude)
        self.largeCircle = CustomMKCircle(center: coordinate, radius: 6000)
        self.largeCircle.tag = 0
        self.middleCircle = CustomMKCircle(center: coordinate, radius: 4000)
        self.middleCircle.tag = 1
        self.smallCircle = CustomMKCircle(center: coordinate, radius: 2000)
        self.smallCircle.tag = 2
        
        super.init(annotation: nil, reuseIdentifier: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

