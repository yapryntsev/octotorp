//
//  GlobalMapUserLocationTracker.swift
//  Octotorp
//

import Foundation
import MapKit

protocol IGlobalMapUserLocationTracker {
    func set(to mode: MKUserTrackingMode)
}

protocol IGlobalMapUserLocationTrackerOwner: MKMapViewDelegate {
    var isUserLocationVisible: Bool { get }
    var userLocation: MKUserLocation { get }
    var visibleMapRect: MKMapRect { get set }
    var centerCoordinate: CLLocationCoordinate2D { get set }
}

private extension MKMapSize {
    static let userTrackingSize = MKMapSize(width: 4800, height: 4800)
}

final class GlobalMapUserLocationTracker: IGlobalMapUserLocationTracker {

    // Properties
    private var displayLink: CADisplayLink?

    // Properties
    private unowned let owner: MKMapView

    // MARK: - Initialization

    init(owner: MKMapView) {
        self.owner = owner
    }

    // MARK: - IGlobalMapUserLocationTracker

    func set(to mode: MKUserTrackingMode) {
        switch mode {
        case .none:
            stopTracking()
        case .follow, .followWithHeading:
            startTracking()
        @unknown default:
            break
        }
    }

    // MARK: - Private

    private func startTracking() {
        stopTracking()

        let workItem = { [self] in
            displayLink = CADisplayLink(target: self, selector: #selector(interpolateLocation))
            displayLink?.add(to: .main, forMode: .common)
        }

        UIView.animate(withDuration: 0.96) {
            self.setVisibleMapRect(center: self.owner.userLocation.coordinate, animated: true)
        } completion: { _ in
            workItem()
        }
    }

    private func stopTracking() {
        displayLink?.invalidate()
        displayLink = nil
    }

    private func setVisibleMapRect(center: CLLocationCoordinate2D, animated: Bool) {
        let rect = MKMapRect(center: center, size: .userTrackingSize)
        owner.setVisibleMapRect(rect, animated: animated)
    }

    @objc
    private func interpolateLocation() {
        guard let view = owner.view(for: owner.userLocation) else { return }
        let coordinate = owner.convert(view.center, toCoordinateFrom: owner)

        setVisibleMapRect(center: coordinate, animated: false)
    }
}
