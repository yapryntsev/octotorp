//
//  UIColor+PaletteProvider.swift
//  Octotorp
//

import UIKit

extension UIColor {

    public static var styleGuide: PaletteProvider = {
        return PaletteProvider()
    }()
}
