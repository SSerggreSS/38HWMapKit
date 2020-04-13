//
//  ExtensionUIImage.swift
//  38HWMapKit
//
//  Created by Сергей on 05.04.2020.
//  Copyright © 2020 Sergei. All rights reserved.
//

import Foundation
import CoreGraphics
import CoreImage
import UIKit

extension UIImage {

    func resize(width: CGFloat, height: CGFloat) -> UIImage? {
    
        let sizeImage = CGSize(width: width, height: height)
        UIGraphicsBeginImageContext(sizeImage)
        self.draw(in: CGRect(x: 0, y: 0, width: sizeImage.width, height: sizeImage.height))
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        
        return resultImage
    }

}
