//
//  HubViewController.swift
//  Octotorp
//

import UIKit

protocol IHubViewController: IAlertPresentable {
    func apply(snapshot: HubDiffableDataSnapshot)
}

final class HubViewController: UIViewController {

    // UI
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(layoutProvider: layoutProvider)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self

        collectionView.register(WidgetSectionTitleCell.self, of: ElementKind.sectionHeader)
        collectionView.register(SearchWidgetCell.self)
        collectionView.register(RouteWidgetCell.self)

        return collectionView
    }()

    // Properties
    private lazy var collectionViewDataSource: HubDataSource = {
        let dataSource = HubDataSource(collectionView: collectionView) { collection, indexPath, model in
            guard let secion = HubSection.init(rawValue: indexPath.section) else {
                fatalError()
            }

            let cell: UICollectionViewCell

            switch secion {
            case .search:
                let instance: SearchWidgetCell = collection.dequeueCell(for: indexPath)
                instance.configure(with: model)
                cell = instance
            case .routes:
                let instance: RouteWidgetCell = collection.dequeueCell(for: indexPath)
                instance.configure(with: model)
                cell = instance
            default:
                fatalError("not supported")
            }

            return cell
        }

        dataSource.supplementaryViewProvider = { collection, kind, indexPath in
            guard let secion = HubSection(rawValue: indexPath.section) else {
                fatalError()
            }

            let supplementary: WidgetSectionTitleCell = collection.dequeueSupplementary(kind: kind, for: indexPath)
            let model: String

            switch secion {
            case .routes:
                model = "Лучшие эко-маршруты"
            default:
                return nil
            }

            supplementary.configure(with: model)
            return supplementary
        }

        return dataSource
    }()

    // Dependencies
    private let layoutProvider: ILayoutProvider
    private let presenetr: IHubPresenter

    // MARK: - Initialization

    init(presenetr: IHubPresenter, layoutProvider: ILayoutProvider) {
        self.presenetr = presenetr
        self.layoutProvider = layoutProvider
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        setup()
        super.viewDidLoad()
        presenetr.viewDidLoad()
    }

    // MARK: - Private

    private func setup() {
        view.backgroundColor = UIColor.styleGuide.c100

        view.addSubview(collectionView)
        collectionView.snp.edgesToSuperview()
    }
}

// MARK: - IHubViewController

extension HubViewController: IHubViewController {

    func apply(snapshot: HubDiffableDataSnapshot) {
        collectionViewDataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension HubViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let secion = HubSection.init(rawValue: indexPath.section) else {
            fatalError()
        }

        switch secion {
        case .search:
            presenetr.userDidSelect(widget: .search)
        case .routes:
            presenetr.userDidSelect(widget: .route(indexPath.row))
        case .awards:
            break
        }

    }
}
