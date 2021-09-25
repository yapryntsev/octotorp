//
//  GrabberView.swift
//  Octotorp
//

import UIKit

private extension CGFloat {
    static let grabberHeight = CGFloat(24)
}

private extension CGSize {
    static let grabberLayerSize = CGSize(width: 48, height: 6)
}

final class GrabberView: UIView {

    // Properties
    private let action: (UIPanGestureRecognizer) -> Void

    // UI
    private lazy var grabberLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.styleGuide.c1000.withAlphaComponent(0.16).cgColor
        return layer
    }()

    // MARK: - Initialization

    init(action: @escaping (UIPanGestureRecognizer) -> Void) {
        self.action = action
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func layoutSubviews() {
        let size = CGSize.grabberLayerSize
        let origin = CGPoint(
            x: center.x - (size.width / 2),
            y: (.grabberHeight / 2) - (size.height / 2)
        )
        grabberLayer.frame = .init(origin: origin, size: size)
        grabberLayer.cornerRadius = grabberLayer.bounds.height / 2
    }

    // MARK: - Private

    private func setup() {
        layer.addSublayer(grabberLayer)

        snp.makeConstraints { make in
            make.height.equalTo(CGFloat.grabberHeight)
        }

        let gesturesRecognizer = UIPanGestureRecognizer(
            target: self,
            action: #selector(grabberDidScroll(recognizer:))
        )
        addGestureRecognizer(gesturesRecognizer)
    }

    @objc
    private func grabberDidScroll(recognizer: UIPanGestureRecognizer) {
        action(recognizer)
    }
}
