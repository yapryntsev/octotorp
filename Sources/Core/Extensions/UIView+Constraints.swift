//
//  UIView+Constraints.swift
//  Octotorp
//

import UIKit
import SnapKit

public extension ConstraintViewDSL {

    func edgesToSuperview(with insets: UIEdgeInsets = .zero) {
        makeConstraints({
            $0.edges.equalToSuperview().inset(insets)
        })
    }
}
