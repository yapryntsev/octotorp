//
//  UIButton+UIAction.swift
//  Octotorp
//

import UIKit

extension UIButton {

    public func addAction(_ action: UIAction) {
        self.addAction(action, for: .touchUpInside)
    }

    public func addAction(_ handler: @escaping () -> Void, for event: UIControl.Event = .touchUpInside) {
        self.addAction(.init(handler: { _ in handler() }), for: event)
    }
}
