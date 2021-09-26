//
//  HubCoordinator.swift
//  Octotorp
//

import UIKit

final class HubCoordinator: ICoordinator {

    // Dependencies
    private weak var transitionHandler: IRootContainer?
    private var child: ICoordinator?

    func start(transitionHandler: IRootContainer?) {
        self.transitionHandler = transitionHandler
        showHub()
    }

    // MARK: - Private

    private func startNavigationCoordinator(route: Route? = nil) {
        let coordinator = NavigationCoordinator()
        child = coordinator

        coordinator.start(transitionHandler: transitionHandler, route: route)
    }

    private func showAchievementsCoordinator() {
        // TODO: добавить реализацию
    }

    private func showHub() {
        let assembly = HubAssembly()
        let controller = assembly.assemble { [weak self] item in
            switch item {
            case .search:
                self?.startNavigationCoordinator()
            case .award:
                break
            case .route(let route):
                self?.startNavigationCoordinator(route: route)
            }
        }

        transitionHandler?.setHub(controller)
        transitionHandler?.showHub(animated: true)
    }
}
