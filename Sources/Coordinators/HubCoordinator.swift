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

    private func startNavigationCoordinator() {
        let coordinator = NavigationCoordinator()
        child = coordinator

        coordinator.start(transitionHandler: transitionHandler)
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
            case .route(_):
                break
            }
        }

        transitionHandler?.setHub(controller)
        transitionHandler?.showHub(animated: true)
    }
}
