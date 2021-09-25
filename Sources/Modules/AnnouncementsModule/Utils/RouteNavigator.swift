//
//  RouteNavigator.swift
//  Octotorp
//

import MapKit
import Foundation
import CoreLocation

protocol IRouterNavigator {
    func navigate()
}

protocol IRouterNavigatorDelegate: AnyObject {
    func stepStarted(step: Route.Step)
    func positionDidChange(to: CLLocationCoordinate2D)
    func navigationFinished()
}

private extension String {
    static let regionIdentifier = "identifier"
}

private extension CLLocationDistance {
    static let regionRadius = CLLocationDistance(1)
}

final class RouteNavigator: NSObject, IRouterNavigator {

    // Properties
    private let route: Route
    private var currentStepIndex: Int = 0
    private var currentRegion: CLCircularRegion?

    // Dependencies
    weak var delegate: IRouterNavigatorDelegate?
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        return manager
    }()

    // MARK: - Initialization

    init(route: Route) {
        self.route = route
    }

    // MARK: - IRouterNavigator

    func navigate() {
        monitor(step: route.steps[currentStepIndex])
        locationManager.startUpdatingLocation()
    }

    // MARK: - Private

    private func monitor(step: Route.Step) {
        let count = step.polyline.pointCount
        let range = NSRange(location: 0, length: count)
        var coordinates = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid, count: count)

        step.polyline.getCoordinates(&coordinates, range: range)
        guard let coordinate = coordinates.last else { fatalError("Expected MKPolyline with 2 coordinates") }

        currentRegion = CLCircularRegion(
            center: coordinate,
            radius: .regionRadius,
            identifier: .regionIdentifier
        )
    }

    private func regionFired() {
        if route.steps.indices.contains(currentStepIndex) {
            let step = route.steps[currentStepIndex]
            monitor(step: step)
            delegate?.stepStarted(step: step)
        } else {
            delegate?.navigationFinished()
        }

        currentStepIndex += 1
    }
}

// MARK: - CLLocationManagerDelegate

extension RouteNavigator: CLLocationManagerDelegate {

    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let location = locations.last else { return }
        delegate?.positionDidChange(to: location.coordinate)

        guard let region = currentRegion,
              region.center.distance(to: location.coordinate) <= 1
        else { return }

        regionFired()
    }
}
