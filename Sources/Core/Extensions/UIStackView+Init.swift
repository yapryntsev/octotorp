//
//  UIStackView+Init.swift
//  Octotorp
//

import UIKit

extension UIStackView {

    convenience init(
        axis: NSLayoutConstraint.Axis = .vertical,
        spacing: CGFloat = 0,
        @ViewBuilder builder: () -> ViewBuilder.FinalResult
    ) {
        self.init(subviews: builder(), spacing: spacing, axis: axis)
    }

    convenience init(subviews: [UIView], spacing: CGFloat = 0, axis: NSLayoutConstraint.Axis = .vertical) {
        self.init(arrangedSubviews: subviews)
        self.spacing = spacing
        self.axis = axis
    }
}
