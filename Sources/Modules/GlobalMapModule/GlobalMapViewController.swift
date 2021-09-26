//
//  GlobalMapViewController.swift
//  Octotorp
//

import UIKit
import MapKit

protocol IGloblMapView: UIViewController {
    func healthMap(overlays: [(UIColor, MKHexagon)])
    func configure(with model: GlobalMapState)
}

protocol IColorProivder: AnyObject {
    func color(for overlay: MKHexagon) -> UIColor
}

final class GlobalMapViewController: UIViewController, IGloblMapView {

    // Properties
    private var healthMapItems = [(UIColor, MKHexagon)]()

    // Dependencies
    private let presenter: IGlobalMapPresenter

    // UI
    private lazy var map: GloblMapView = {
        let map = GloblMapView()
        map.colorProvider = self
        return map
    }()

    // MARK: - Initialization

    init(presenter: IGlobalMapPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.viewDidAppear()
    }

    // MARK: - Private

    private func setup() {
        let shadowWrapper = UIView()
        shadowWrapper.addSubview(map)
        map.snp.edgesToSuperview()

        shadowWrapper.layer.shadowColor = UIColor.styleGuide.c100.dark.cgColor
        shadowWrapper.layer.shadowRadius = .baseRadius
        shadowWrapper.layer.shadowOpacity = 0.12
        shadowWrapper.layer.shadowOffset = .init(width: 0, height: 4)

        view.addSubview(shadowWrapper)
        shadowWrapper.snp.edgesToSuperview()

        let center = CLLocationCoordinate2D(latitude: 55.7522200, longitude: 37.6155600)

        let rect = MKMapRect(
            center: center,
            size: .init(width: 350000, height: 350000)
        )
        map.setVisibleMapRect(
            rect,
            edgePadding: .init(top: 16, left: 16, bottom: 414 + 64, right: 16),
            animated: false
        )
    }
}

// MARK: - IColorProivder

extension GlobalMapViewController: IColorProivder {

    func color(for overlay: MKHexagon) -> UIColor {
        let item = healthMapItems.first(where: { $0.1 == overlay })
        return item!.0
    }
}

// MARK: - Configurable

extension GlobalMapViewController: Configurable {

    func healthMap(overlays: [(UIColor, MKHexagon)]) {
        healthMapItems = overlays
        let overlays = healthMapItems.map { $0.1 }
        map.addOverlays(overlays, level: .aboveRoads)
    }

    func configure(with state: GlobalMapState) {
        map.mapType = state.mapType
        map.pointOfInterestFilter = state.pointOfInterestFilter
        map.showsUserLocation = state.showsUserLocation
        map.isUserInteractionEnabled = state.isUserInteractionEnabled

        map.setUserTrackingMode(state.userTrackingMode, animated: true)
        map.setUserTrackingButton(visisble: state.isUserTrackingButtonVisible, animated: true)

        map.removeOverlays(map.overlays)
        map.removeAnnotations(map.annotations)

        if state.shouldShowHealthMap {
            let overlays = healthMapItems.map { $0.1 }
            map.addOverlays(overlays, level: .aboveRoads)
        }


        if let route = state.route {

            let annotations = [route.steps[0], route.steps[route.steps.count - 1]].map { step -> MKPointAnnotation in
                let annotation = MKPointAnnotation()
                annotation.coordinate = step.start
                return annotation
            }

            map.addAnnotations(annotations)
            map.addOverlay(route.polyline)

            if state.showRouteReview {
                map.setVisibleMapRect(
                    route.polyline.boundingMapRect,
                    animated: true
                )
            }
        }
    }
}
