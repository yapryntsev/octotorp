//
//  UIView+VibrancyEffect.swift
//  Octotorp
//

import UIKit

extension UIView {

    public func wrappedInVibrancy(blurEffect: UIBlurEffect, style: UIVibrancyEffectStyle) -> UIView {
        let effect = UIVibrancyEffect(blurEffect: blurEffect, style: style)
        let wrapper = UIVisualEffectView(effect: effect)

        wrapper.contentView.addSubview(self)
        self.snp.edgesToSuperview()

        return wrapper
    }
}
