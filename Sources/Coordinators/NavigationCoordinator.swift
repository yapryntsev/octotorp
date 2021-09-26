//
//  NavigationCoordinator.swift
//  Octotorp
//

import UIKit

final class NavigationCoordinator: ICoordinator {

    // Dependencies
    private weak var transitionHandler: IRootContainer?

    func start(transitionHandler: IRootContainer?) {
        self.transitionHandler = transitionHandler
        showSearch()
    }

    func start(transitionHandler: IRootContainer?, route: Route?) {
        guard let route = route else {
            return start(transitionHandler: transitionHandler)
        }
        self.transitionHandler = transitionHandler
        self.transitionHandler?.hideHub(animated: true)
        
        showNavigationAnnouncement(for: route)
    }

    // MARK: - Private

    private func showSearch() {
        let assembly = SearchAssembly()
        let controller = assembly.assemble { [weak self] result, controller in
            self?.transitionHandler?.hideHub(animated: true)
            controller.dismiss(animated: true)
            self?.showRoutePicker(for: result)
        }

        transitionHandler?.present(controller, animated: true)
    }

    private func showRoutePicker(for searchResult: SearchResultItem) {
        guard let container = transitionHandler else { return }

        let assembly = RoutePickerAssembly()
        let controller = assembly.assemble(direction: searchResult, container: container) { [weak self] output in
            switch output {
            case .selected(let route):
                self?.showNavigationAnnouncement(for: route)
                self?.transitionHandler?.removeWidget(.bottom, animated: true)
            case .close:
                self?.transitionHandler?.showHub(animated: true)
                self?.transitionHandler?.removeWidget(.top, animated: true)
                self?.transitionHandler?.removeWidget(.bottom, animated: true)
            case .changeDeparture:
                break
            }
        }

        transitionHandler?.set(widget: controller, as: .top, animated: true)
    }

    private func showNavigationAnnouncement(for route: Route) {
        let assembly = AnnouncementsAssembly()
        let controller = assembly.assemble(route: route, output: transitionHandler)

        transitionHandler?.set(widget: controller, as: .top, animated: true)
    }
}
