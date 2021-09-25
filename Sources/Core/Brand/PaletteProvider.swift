//
//  PaletteProvider.swift
//  Octotorp
//

import UIKit

private extension UIColor {
    static let reservePrimaryColor = UIColor.darkGray
}

private extension String {
    static let primaryColorKey = "primary"
    static let secondaryColorKey = "secondary"
}

public final class PaletteProvider {

    // MARK: - Private

    private func color(light: UIColor, dark: UIColor) -> UIColor {

        return UIColor { trait -> UIColor in
            if trait.userInterfaceStyle == .dark {
                return dark
            }
            return light
        }
    }

    // MARK: - Public

    public lazy var primary: UIColor = {
        return UIColor(hex: "#D9232E")
    }()

    public lazy var primaryLight: UIColor = {
        return UIColor(hex: "#FCECED")
    }()

    public lazy var primaryDark: UIColor = {
        return UIColor(hex: "#EAB000")
    }()

    public lazy var c100: UIColor = {
        return color(light: UIColor(hex: "#FFFFFF"), dark: UIColor(hex: "#000000"))
    }()

    public lazy var c150: UIColor = {
        return color(light: UIColor(hex: "#F5F5F5"), dark: UIColor(hex: "#151515"))
    }()

    public lazy var c200: UIColor = {
        return color(light: UIColor(hex: "#EEEEEE"), dark: UIColor(hex: "#1A1A1A"))
    }()

    public lazy var c250: UIColor = {
        return color(light: UIColor(hex: "#E6E6E6"), dark: UIColor(hex: "#1F1F1F"))
    }()

    public lazy var c300: UIColor = {
        return color(light: UIColor(hex: "#DDDDDD"), dark: UIColor(hex: "#262626"))
    }()

    public lazy var c400: UIColor = {
        return color(light: UIColor(hex: "#CFCFCF"), dark: UIColor(hex: "#303030"))
    }()

    public lazy var c500: UIColor = {
        return color(light: UIColor(hex: "#C2C2C2"), dark: UIColor(hex: "#404040"))
    }()

    public lazy var c600: UIColor = {
        return color(light: UIColor(hex: "#B3B3B3"), dark: UIColor(hex: "#4D4D4D"))
    }()

    public lazy var c700: UIColor = {
        return color(light: UIColor(hex: "#A3A3A3"), dark: UIColor(hex: "#595959"))
    }()

    public lazy var c800: UIColor = {
        return color(light: UIColor(hex: "#949494"), dark: UIColor(hex: "#696969"))
    }()

    public lazy var c900: UIColor = {
        return color(light: UIColor(hex: "#888888"), dark: UIColor(hex: "#757575"))
    }()

    public lazy var c1000: UIColor = {
        return color(light: UIColor(hex: "#000000"), dark: UIColor(hex: "#FFFFFF"))
    }()

    public lazy var modal: UIColor = {
        return color(light: UIColor(hex: "#FFFFFF"), dark: UIColor(hex: "#151515"))
    }()
}
