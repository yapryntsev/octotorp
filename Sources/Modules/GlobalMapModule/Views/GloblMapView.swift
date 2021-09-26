//
//  GloblMapView.swift
//  Octotorp
//

import UIKit
import MapKit
import CoreLocation
import PromiseKit

private extension Double {
    static let userTrackingButtonVisibilityDuration = 0.16
}

final class GloblMapView: MKMapView {

    // UI
    private lazy var userTrackingButton: UIView = {
        let button = GlobalMapUserTrackingButton(map: self)
        delegates.append(button)
        return button
    }()

    // Properties
    var delegates = [MKMapViewDelegate]()
    private lazy var userLocationTracker: GlobalMapUserLocationTracker = {
        return GlobalMapUserLocationTracker(owner: self)
    }()

    // Dependencies
    weak var colorProvider: IColorProivder?

    // MARK: - Initialization

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        guard
            let touchView = touches.first?.view,
            !touchView.isDescendant(of: userTrackingButton)
        else { return }

        setUserTrackingMode(.none, animated: false)
    }

    // MARK: - Public

    func setUserTrackingButton(visisble: Bool, animated: Bool) {
        UIView.animate(withDuration: animated ? .userTrackingButtonVisibilityDuration : .zero) {
            self.userTrackingButton.isHidden = !visisble
        }
    }

    override func setUserTrackingMode(_ mode: MKUserTrackingMode, animated: Bool) {
        mapView(self, didChange: mode, animated: animated)
        userLocationTracker.set(to: mode)
    }

    override func setVisibleMapRect(_ mapRect: MKMapRect, animated animate: Bool) {
        let insets = UIEdgeInsets(top: 48, left: 48, bottom: 48, right: 48)
        super.setVisibleMapRect(mapRect, edgePadding: insets, animated: animate)
    }

    // MARK: - Private

    private func setup() {
        delegate = self
        showsScale = false
        showsCompass = false

        cornerRadius(.extraLargeRadius, mask: true)

        addSubview(userTrackingButton)
        userTrackingButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).inset(CGFloat.compactSpace)
            $0.trailing.equalToSuperview().inset(CGFloat.compactSpace)
        }
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay.isKind(of: MKPolyline.self) {
            let polylineRenderer = MKGradientPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.styleGuide.primary
            polylineRenderer.lineWidth = 6
            polylineRenderer.lineJoin = .bevel

            return polylineRenderer
        }

        if let polygon = overlay as? MKHexagon {
            let renderer = MKPolygonRenderer(polygon: polygon)
            renderer.fillColor = colorProvider?.color(for: polygon)

            return renderer
        }

        return MKOverlayRenderer(overlay: overlay)
    }
}

// MARK: - MKMapViewDelegate

extension GloblMapView: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
        delegates.forEach {
            $0.mapView?(mapView, didChange: mode, animated: animated)
        }
    }
}
