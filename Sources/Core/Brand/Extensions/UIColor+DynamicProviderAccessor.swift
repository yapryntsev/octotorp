//
//  UIColor+DynamicProviderAccessor.swift
//  Octotorp
//

import UIKit

public extension UIColor {

    var light: UIColor {
        return resolvedColor(with: .init(userInterfaceStyle: .light))
    }

    var dark: UIColor {
        return resolvedColor(with: .init(userInterfaceStyle: .dark))
    }
}
