//
//  UIColor+Hex.swift
//  Octotorp
//

import UIKit

extension UIColor {

    var hex: String {
        get{
            let colorComponents = self.cgColor.components!
            if colorComponents.count < 4 {
                return String(format: "%02x%02x%02x", Int(colorComponents[0]*255.0), Int(colorComponents[0]*255.0),Int(colorComponents[0]*255.0)).uppercased()
            }
            return String(format: "%02x%02x%02x", Int(colorComponents[0]*255.0), Int(colorComponents[1]*255.0),Int(colorComponents[2]*255.0)).uppercased()
        }
    }
}
