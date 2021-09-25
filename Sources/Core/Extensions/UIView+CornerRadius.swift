//
//  UIView+CornerRadius.swift
//  Octotorp
//

import UIKit

public extension UIView {

    func round(mask: Bool = false) {
        layer.cornerRadius = floor(bounds.height / 2)
        layer.cornerCurve = .continuous
        layer.masksToBounds = mask
    }

    func cornerRadius(_ radius: CGFloat, mask: Bool = false) {
        layer.cornerCurve = .continuous
        layer.cornerRadius = radius
        layer.masksToBounds = mask
    }
}
