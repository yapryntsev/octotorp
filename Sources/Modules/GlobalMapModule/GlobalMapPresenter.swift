//
//  GlobalMapPresenter.swift
//  Octotorp
//

import Foundation

protocol IGlobalMapPresenter {
    func viewDidLoad()
    func viewDidAppear()
}

final class GlobalMapPresenter {

    // Properties
    weak var view: IGloblMapView?
    private let stateFactory: IGlobalMapStateFactory

    // MARK: - Initialization

    init(stateFactory: IGlobalMapStateFactory) {
        self.stateFactory = stateFactory
    }
}

// MARK: - IGlobalMapPresenter

extension GlobalMapPresenter: IGlobalMapPresenter {

    func viewDidLoad() {

    }

    func viewDidAppear() {
        let routeService = RouteService()
        let route = routeService.route(
            start: .init(),
            end: .init()
        )

        let state = stateFactory.explore()
        view?.configure(with: state)
    }
}
