//
//  UIView+Blur.swift
//  Octotorp
//

import UIKit

extension UIView {

    public func wrappedInBlur(style: UIBlurEffect.Style) -> UIVisualEffectView {
        let effect = UIBlurEffect(style: style)
        let wrapper = UIVisualEffectView(effect: effect)

        wrapper.contentView.addSubview(self)
        self.snp.edgesToSuperview()

        return wrapper
    }
}
