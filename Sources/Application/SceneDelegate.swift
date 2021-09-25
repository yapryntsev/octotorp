//
//  SceneDelegate.swift
//  Octotorp
//

import UIKit

extension String {
    static let graphhopperKey = "1b65a66f-97e8-448d-a80a-e9694ffa5306"
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: IRootCoordinator?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)

        coordinator = RootCoordinator()
        coordinator?.start(on: window)
    }
}
