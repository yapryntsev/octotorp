//
//  RootCoordinator.swift
//  Octotorp
//

import UIKit

protocol IRootCoordinator {
    func start(on window: UIWindow?)
}

final class RootCoordinator: IRootCoordinator {

    // Properties
    private weak var transitionHandler: IRootContainer?
    private var child: ICoordinator?

    // MARK: - IRootCoordinator

    func start(on window: UIWindow?) {
        setupRoot(on: window)
        startHubCoordinator()
    }

    // MARK: - Private

    private func setupRoot(on window: UIWindow?) {
        let rootAssembly = RootAssembly()
        let mapAssembly = GlobalMapAssembly()

        let map = mapAssembly.assemble()
        let root = rootAssembly.assemble(map: map)

        transitionHandler = root

        window?.rootViewController = root
        window?.makeKeyAndVisible()
    }

    private func startHubCoordinator() {
        let coordinator = HubCoordinator()
        child = coordinator

        coordinator.start(transitionHandler: transitionHandler)
    }
}
