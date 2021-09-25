//
//  RouteNavigationFacade.swift
//  Octotorp
//

import Foundation
import MapKit

protocol IRouteNavigationFacade {
    var route: Route { get }
    func navigate()
}

protocol IRouteNavigationDelegate: AnyObject {
    func annonce(step: Route.Step)
}

final class RouteNavigationFacade: IRouteNavigationFacade {

    // Dependencies
    private let navigator: IRouterNavigator
    let announcer: RouteAnnouncer

    let route: Route

    weak var delegate: IRouteNavigationDelegate?

    // MARK: - Initialization

    init(route: Route) {
        self.route = route

        let navigator = RouteNavigator(route: route)
        self.navigator = navigator

        let viewModelFactory = AnnouncementViewModelFactory()
        let announcer = RouteAnnouncer(steps: route.steps, viewModelFactory: viewModelFactory)
        self.announcer = announcer

        navigator.delegate = self
    }

    // MARK: - IRouteNavigationFacade

    func navigate() {
        navigator.navigate()
    }

    func present(on map: MKMapView) {
        // TODO: a.yapryntsev добавить реализацию
    }
}

// MARK: - IRouterNavigatorDelegate

extension RouteNavigationFacade: IRouterNavigatorDelegate {

    func positionDidChange(to location: CLLocationCoordinate2D) {
        announcer.updtaeAnnonce(with: location)
    }

    func stepStarted(step: Route.Step) {
        announcer.annonce(step: step)
    }

    func navigationFinished() {
        // TODO: a.yapryntsev добавить реализацию
    }
}
