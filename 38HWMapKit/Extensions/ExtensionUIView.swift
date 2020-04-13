//
//  ExtensionUIView.swift
//  38HWMapKit
//
//  Created by Сергей on 03.04.2020.
//  Copyright © 2020 Sergei. All rights reserved.
//

import Foundation
import MapKit

extension UIView {
    
    func superAnnotationView() -> MKAnnotationView? {
    
        if self is MKAnnotationView {
            return self as? MKAnnotationView
        }
        
        if self.superview == nil {
            return nil
        }
        
        return self.superview?.superAnnotationView()
    }
    
}
