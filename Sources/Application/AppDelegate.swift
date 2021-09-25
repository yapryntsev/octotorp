//
//  AppDelegate.swift
//  Octotorp
//

import UIKit
import CoreLocation
import SkeletonView

private extension Int {
    static let multilineCornerRadius = 6
}

private extension CGFloat {
    static let multilineSpacing: CGFloat = 6
    static let multilineHeight: CGFloat = 12
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        return manager
    }()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        if locationManager.authorizationStatus != .authorizedAlways {
            locationManager.requestAlwaysAuthorization()
        }

        SkeletonAppearance.default.tintColor = .styleGuide.c150

        SkeletonAppearance.default.gradient = SkeletonGradient(
            baseColor: .styleGuide.c150,
            secondaryColor: .styleGuide.c200
        )

        SkeletonAppearance.default.multilineHeight = .multilineHeight
        SkeletonAppearance.default.multilineSpacing = .multilineSpacing
        SkeletonAppearance.default.multilineCornerRadius = .multilineCornerRadius

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

extension AppDelegate: CLLocationManagerDelegate { }
