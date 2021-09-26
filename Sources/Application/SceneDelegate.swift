//
//  SceneDelegate.swift
//  Octotorp
//

import UIKit

extension String {
    static let graphhopperKey = "Ваш ключ"
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
