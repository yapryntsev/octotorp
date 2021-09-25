//
//  RootViewController.swift
//  Octotorp
//

import UIKit
import MapKit
import SnapKit

typealias IRootContainer = IRootWidgetContainer & IRootHubContainer

enum RootWidgetPosition {
    case top
    case bottom
}

protocol IRootWidgetContainer: AnyObject {
    var map: IGloblMapView { get }

    func set(widget: UIViewController, as position: RootWidgetPosition, animated: Bool)
    func removeWidget(_ position: RootWidgetPosition, animated: Bool)

    func widgetDidChangeLayout()
}

protocol IRootHubContainer: UIViewController {
    func setHub(_ hub: UIViewController)
    func showHub(animated: Bool)
    func hideHub(animated: Bool)
}

private extension TimeInterval {
    static let animationDuration = 0.4
}

final class RootViewController: UIViewController {

    // Properties
    private var hubController: UIViewController?
    private var topWidgetController: UIViewController?
    private var bottomWidgetController: UIViewController?

    // Dependencies
    let map: IGloblMapView
    private let presenter: IRootPresenter

    // UI
    private lazy var container: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()

    // MARK: - Initialization

    init(map: IGloblMapView, presenter: IRootPresenter) {
        self.map = map
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        setup()
    }

    // MARK: - Private

    private func setup() {
        // Setup view
        view.backgroundColor = UIColor.styleGuide.c100

        // Setup header container
        view.addSubview(container)
        container.snp.edgesToSuperview()

        // Setup map
        addChild(map)
        container.addArrangedSubview(map.view)
        map.didMove(toParent: self)
        map.view.layer.zPosition = 900
    }

    private func current(at position: RootWidgetPosition) -> UIViewController? {
        switch position {
        case .top:
            return topWidgetController
        case .bottom:
            return bottomWidgetController
        }
    }
}

// MARK: - IRootContainer

extension RootViewController: IRootContainer {

    func set(widget: UIViewController, as position: RootWidgetPosition, animated: Bool) {

        defer {
            switch position {
            case .top:
                topWidgetController = widget
            case .bottom:
                bottomWidgetController = widget
            }
            widget.didMove(toParent: self)
        }

        addChild(widget)
        widget.view.isHidden = true
        let current = current(at: position)

        let position = position == .top ? 0 : container.arrangedSubviews.count
        container.insertArrangedSubview(widget.view, at: position)

        widget.view.isHidden = true
        widget.view.alpha = 0

        UIView.animate(withDuration: animated ? .animationDuration : .zero) {
            current?.view.alpha = 0
            widget.view.alpha = 1
            current?.view.isHidden = true
            widget.view.isHidden = false
        } completion: { _ in
            current?.willMove(toParent: nil)
            current?.view.removeFromSuperview()
            current?.removeFromParent()
        }
    }

    func removeWidget(_ position: RootWidgetPosition, animated: Bool) {
        let current = current(at: position)
        let workItem = {
            current?.willMove(toParent: nil)
            current?.view.removeFromSuperview()
            current?.removeFromParent()
        }

        guard animated else { return workItem() }

        UIView.animate(withDuration: .animationDuration) {
            current?.view.isHidden = true
        } completion: { _ in
            workItem()
        }
    }

    func widgetDidChangeLayout() {
        view.layoutIfNeeded()
    }


    func setHub(_ controller: UIViewController) {
        hubController = controller
    }

    func showHub(animated: Bool) {
        guard let controller = hubController else { return }

        if let sheet = controller.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.preferredCornerRadius = .baseRadius
            sheet.prefersGrabberVisible = true
            sheet.delegate = self
            sheet.largestUndimmedDetentIdentifier = .large
            sheet.preferredCornerRadius = .extraLargeRadius
        }

        present(controller, animated: animated)
    }

    func hideHub(animated: Bool) {
        dismiss(animated: animated)
    }
}

// MARK: - UISheetPresentationControllerDelegate

extension RootViewController: UISheetPresentationControllerDelegate {

    func presentationControllerShouldDismiss(
        _ presentationController: UIPresentationController
    ) -> Bool {
        return false
    }
}

// MARK: - Custom presentation logic

extension RootViewController {

    override func present(
        _ viewControllerToPresent: UIViewController,
        animated flag: Bool,
        completion: (() -> Void)? = nil
    ) {
        guard var transitionHandler = self.presentedViewController else {
            return super.present(viewControllerToPresent, animated: true, completion: nil)
        }

        while let controller = transitionHandler.presentedViewController {
            transitionHandler = controller
        }
        transitionHandler.present(viewControllerToPresent, animated: true, completion: nil)
    }
}
