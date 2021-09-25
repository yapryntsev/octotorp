//
//  FontProvider.swift
//  Octotorp
//

import UIKit

public final class FontProvider {

    // MARK: - Public

    public var heading1: UIFont {
        return .systemFont(ofSize: 36, weight: .bold)
    }

    public var heading2: UIFont {
        return .systemFont(ofSize: 32, weight: .bold)
    }

    public var heading3: UIFont {
        return .systemFont(ofSize: 28, weight: .bold)
    }

    public var heading4: UIFont {
        return .systemFont(ofSize: 24, weight: .bold)
    }

    public var heading5: UIFont {
        return .systemFont(ofSize: 20, weight: .bold)
    }

    public var heading6: UIFont = {
        return .systemFont(ofSize: 18, weight: .bold)
    }()

    public var headline1: UIFont = {
        return .systemFont(ofSize: 22, weight: .regular)
    }()

    public var headline2: UIFont = {
        return .systemFont(ofSize: 18, weight: .regular)
    }()

    public var body1: UIFont {
        return .systemFont(ofSize: 16, weight: .regular)
    }

    public var body2: UIFont {
        return .systemFont(ofSize: 14, weight: .regular)
    }

    public var caption1: UIFont {
        return .systemFont(ofSize: 12, weight: .bold)
    }

    public var caption2: UIFont {
        return .systemFont(ofSize: 12, weight: .regular)
    }

    public var button: UIFont {
        return .systemFont(ofSize: 16, weight: .medium)
    }
}
