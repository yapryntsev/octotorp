//
//  GlobalMapUserTrackingButton.swift
//  Octotorp
//

import UIKit
import MapKit

final class GlobalMapUserTrackingButton: UIView {

    // UI
    private lazy var iconImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()

    // Properties
    private var currentState: MKUserTrackingMode = .none
    private var observation: NSKeyValueObservation?

    // Dependencies
    private weak var map: MKMapView?

    // MARK: - Initialization

    init(map: MKMapView) {
        self.map = map
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private

    private func setup() {
        changeStateIfNeeded(to: .none)

        // Setup button
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(userDidTapButton))
        addGestureRecognizer(recognizer)
        snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 48, height: 48))
        }

        // Setup blur
        let blur = UIBlurEffect(style: .prominent)
        let effectView = UIVisualEffectView(effect: blur)
        effectView.cornerRadius(.baseRadius, mask: true)

        addSubview(effectView)
        effectView.snp.edgesToSuperview()

        // Setup icon image view
        let iconWrapper = iconImageView.wrappedInVibrancy(blurEffect: blur, style: .fill)
        addSubview(iconWrapper)
        iconWrapper.snp.edgesToSuperview(with: .init(all: .compactSpace))

        layer.shadowColor = UIColor.styleGuide.c100.dark.cgColor
        layer.shadowRadius = .baseRadius
        layer.shadowOpacity = 0.08
        layer.shadowOffset = CGSize(width: 0, height: 2)
    }

    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {

    }

    @objc
    private func userDidTapButton() {
        guard let map = map else { return }
        switch currentState {
        case .none:
            map.setUserTrackingMode(.follow, animated: true)
        case .follow:
            map.setUserTrackingMode(.followWithHeading, animated: true)
        case .followWithHeading:
            map.setUserTrackingMode(.follow, animated: true)
        @unknown default:
            break
        }
    }

    private func changeStateIfNeeded(to state: MKUserTrackingMode) {
        currentState = state
        switch state {
        case .none:
            iconImageView.image = UIImage(systemName: "location")
        case .follow:
            iconImageView.image = UIImage(systemName: "location.fill")
        case .followWithHeading:
            iconImageView.image = UIImage(systemName: "location.north.line.fill")
        @unknown default:
            break
        }
    }
}

extension GlobalMapUserTrackingButton: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
        guard currentState != mode else { return }
        changeStateIfNeeded(to: mode)
    }
}
