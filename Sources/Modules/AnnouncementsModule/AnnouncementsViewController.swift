//
//  AnnouncementsViewController.swift
//  Octotorp
//

import UIKit
import SnapKit

private extension CGFloat {
    static let expandedHeight = CGFloat(544)
    static let collapsedHeight = CGFloat(160)
}

private extension CGSize {
    static let voiceButtonSize = CGSize(width: 40, height: 40)
}

private enum State {
    case expanded
    case collapsed

    var change: State {
        switch self {
        case .expanded: return .collapsed
        case .collapsed: return .expanded
        }
    }
}

final class AnnouncementsViewController: UIViewController {

    // Properties
    private var state: State = .collapsed
    private lazy var animator: UIViewPropertyAnimator = {
        return UIViewPropertyAnimator(duration: 0.56, dampingRatio: 0.64)
    }()

    // UI
    private lazy var voiceAnnounceButton: UIButton = {
        let button = UIButton.styleGuide.voice
        button.addAction { [weak self] in

        }
        return button
    }()

    lazy var collectionView: UICollectionView = {
        let layoutProvider = AnnouncementsLayoutFactory()
        let collection = UICollectionView(layoutProvider: layoutProvider)

        collection.backgroundColor = .clear
        collection.isUserInteractionEnabled = false
        collection.clipsToBounds = false
        collection.dataSource = self

        collection.register(AnnouncementItemCell.self)

        return collection
    }()
    private lazy var grabberView: UIView = {
        return GrabberView { [weak self] recognizer in
            self?.userDidScrollGrabber(recognizer: recognizer)
        }
    }()

    // Dependencies
    private let presenter: IAnnouncementsPresenter
    private weak var output: IRootWidgetContainer?
    private let announcementsProvider: IAnnouncementsProvider

    // MARK: - Initialization

    init(output: IRootWidgetContainer?,
         presenter: IAnnouncementsPresenter,
         announcementsProvider: IAnnouncementsProvider
    ) {

        self.output = output
        self.presenter = presenter
        self.announcementsProvider = announcementsProvider
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.viewDidAppear()
    }

    private func setup() {
        [collectionView, grabberView, voiceAnnounceButton].forEach {
            view.addSubview($0)
        }

        view.snp.makeConstraints {
            $0.height.equalTo(CGFloat.collapsedHeight)
        }

        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(496)
        }

        grabberView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }

        voiceAnnounceButton.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(CGFloat.normalSpace)
            $0.trailing.equalToSuperview().inset(CGFloat.expandedSpace)
            $0.size.equalTo(CGSize.voiceButtonSize)
        }
    }

    // MARK: - Private

    private func userDidScrollGrabber(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            toggle()
            animator.pauseAnimation()
        case .changed:
            let translation = recognizer.translation(in: view)
            var fraction = translation.y / (.expandedHeight - .collapsedHeight)
            if state == .expanded { fraction *= -1 }
            animator.fractionComplete = min(fraction, 1)
        case .ended:
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        default:
            break
        }
    }

    private func toggle() {
        switch state {
        case .expanded:
            collapse()
        case .collapsed:
            expand()
        }
    }

    private func collapse() {
        collectionView.isUserInteractionEnabled = false

        view.snp.updateConstraints {
            $0.height.equalTo(CGFloat.collapsedHeight)
        }

        animator.addAnimations {
            self.voiceAnnounceButton.alpha = 1
            self.output?.widgetDidChangeLayout()
        }
        animator.addCompletion { position in
            guard position == .end else { return }
            self.announcementsProvider.collapsed()
            self.state = .collapsed
        }

        animator.startAnimation()
    }

    private func expand() {
        collectionView.isUserInteractionEnabled = true

        view.snp.updateConstraints {
            $0.height.equalTo(CGFloat.expandedHeight)
        }

        animator.addAnimations {
            self.voiceAnnounceButton.alpha = 0
            self.output?.widgetDidChangeLayout()
        }
        animator.addCompletion { position in
            guard position == .end else { return }
            self.announcementsProvider.expanded()
            self.state = .expanded
        }

        animator.startAnimation()
    }
}

// MARK: - UICollectionViewDataSource

extension AnnouncementsViewController: UICollectionViewDataSource {

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return announcementsProvider.numberOfAnnouncements()
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {

        let cell: AnnouncementItemCell = collectionView.dequeueCell(for: indexPath)
        let model = announcementsProvider.announcement(at: indexPath)

        cell.configure(with: model)

        return cell
    }
}
