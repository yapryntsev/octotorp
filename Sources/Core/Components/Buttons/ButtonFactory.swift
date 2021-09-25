//
//  ButtonFactory.swift
//  Octotorp
//

import UIKit

final class ButtonFactory {

    public var plain: UIButton {
        let button = UIButton(configuration: .plain(), primaryAction: nil)
        button.cornerRadius(.largeRadius, mask: true)
        return button
    }

    public var filled: UIButton {
        let button = UIButton(configuration: .filled(), primaryAction: nil)
        button.configuration?.baseBackgroundColor = UIColor.styleGuide.primary
        button.cornerRadius(.largeRadius, mask: true)
        return button
    }

    public var tinted: UIButton {
        let button = UIButton(configuration: .tinted(), primaryAction: nil)
        button.cornerRadius(.largeRadius, mask: true)
        return button
    }

    public var gray: UIButton {
        let button = UIButton(configuration: .gray(), primaryAction: nil)
        button.cornerRadius(.largeRadius, mask: true)
        return button
    }

    public var close: UIButton {
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 14, weight: .bold)
        let image = UIImage(systemName: "xmark", withConfiguration: imageConfiguration)

        var configuration = UIButton.Configuration.gray()
        configuration.imagePlacement = .all
        configuration.baseForegroundColor = UIColor.styleGuide.primary
        configuration.image = image

        configuration.baseBackgroundColor = UIColor { trait in
            switch trait.userInterfaceStyle {
            case .dark:
                return UIColor.styleGuide.c300.dark
            default:
                return UIColor.styleGuide.c150.light
            }
        }

        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.cornerRadius(.largeRadius, mask: true)
        
        return button
    }

    public var voice: UIButton {
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 14, weight: .bold)
        let image = UIImage(systemName: "speaker.wave.2.fill", withConfiguration: imageConfiguration)

        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = UIColor.styleGuide.primary
        configuration.imagePlacement = .all
        configuration.image = image

        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.cornerRadius(20, mask: true)

        return button
    }
}
