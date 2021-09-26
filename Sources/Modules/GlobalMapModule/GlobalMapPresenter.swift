//
//  GlobalMapPresenter.swift
//  Octotorp
//

import Foundation
import MapKit

protocol IGlobalMapPresenter {
    func viewDidLoad()
    func viewDidAppear()
}

final class GlobalMapPresenter {

    // Properties
    private var sensors = [HealthSensor]()

    // Dependencies
    weak var view: IGloblMapView?
    private let healthService: IMapHealthService
    private let stateFactory: IGlobalMapStateFactory

    // MARK: - Initialization

    init(stateFactory: IGlobalMapStateFactory, healthService: IMapHealthService) {
        self.healthService = healthService
        self.stateFactory = stateFactory
    }

    // MARK: - Private

    private func getSensors() {
        healthService.sensors(
            top: .init(latitude: 55.266598, longitude: 36.666870),
            bottom: .init(latitude: 56.325675, longitude: 38.660889))
            .done { sensors in
                self.sensors = sensors
                self.makeOverlays()
            }
            .catch { _ in }
    }

    private func makeOverlays() {
        let overlays: [(UIColor, MKHexagon)] = sensors.map { sensor in
            let index = Double(sensor.raiting) * 0.01
            let color = UIColor(hue: 0.33 * index, saturation: 1.0, lightness: 0.5, alpha: 1.0)
                .withAlphaComponent(0.16)
            return (color, .init(center: sensor.coordinate, radius: 1000))
        }
        view?.healthMap(overlays: overlays)
    }
}

// MARK: - IGlobalMapPresenter

extension GlobalMapPresenter: IGlobalMapPresenter {

    func viewDidLoad() {
        getSensors()
    }

    func viewDidAppear() {
        let state = stateFactory.explore()
        view?.configure(with: state)
    }
}
