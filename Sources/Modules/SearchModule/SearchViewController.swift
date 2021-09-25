//
//  SearchViewController.swift
//  Octotorp
//

import UIKit
import SnapKit
import Combine
import SkeletonView

enum SearchSection {
    case favorites
    case searchItems
}

protocol ISearchViewController: IAlertPresentable {
    func apply(snapshot: SearchDiffableDataSnapshot)
    func showSkeleton()
    func hideSkeleton()
}

private extension RunLoop.SchedulerTimeType.Stride {
    static let debounceDelta = RunLoop.SchedulerTimeType.Stride(0.64)
}

private extension String {
    static let viewTitle = "Куда едем?"
}

final class SearchViewController: UIViewController {

    // UI
    private lazy var titleLabel: UILabel = {
        let label = UILabel.styleGuide.heading6
        label.textColor = UIColor.styleGuide.c500
        label.text = .viewTitle
        return label
    }()

    private lazy var searchTextField: UITextField = {
        return UITextField.styleGuide.plain
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(layoutProvider: layoutProvider)
        collectionView.backgroundColor = .clear
        collectionView.isSkeletonable = true
        collectionView.delegate = self

        collectionView.register(SearchItemCell.self)

        return collectionView
    }()

    // Properties
    private lazy var collectionViewDataSource: SearchDiffableDataSource = {
        return SearchDataSource(collectionView: collectionView) { collection, indexPath, model in
            let cell: SearchItemCell = collection.dequeueCell(for: indexPath)
            cell.configure(with: model)
            return cell
        }
    }()
    
    private var subscribers = Set<AnyCancellable>()

    // Dependencies
    private let layoutProvider: ILayoutProvider
    private let presenter: ISearchPresenter

    // MARK: - Initialization

    init(presenter: ISearchPresenter, layoutProvider: ILayoutProvider) {
        self.presenter = presenter
        self.layoutProvider = layoutProvider
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchTextField.becomeFirstResponder()
    }

    // MARK: - Private

    private func setup() {
        view.backgroundColor = UIColor.styleGuide.c100

        [titleLabel, searchTextField, collectionView].forEach {
            view.addSubview($0)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(CGFloat.expandedSpace)
            make.leading.trailing.equalToSuperview().inset(CGFloat.expandedSpace)
        }

        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(CGFloat.tinySpace)
            make.leading.trailing.equalToSuperview().inset(CGFloat.expandedSpace)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(CGFloat.normalSpace)
            make.leading.trailing.equalToSuperview().inset(CGFloat.expandedSpace)
            make.bottom.equalToSuperview()
        }

        // Setup publisher
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: searchTextField)
            .map { ($0.object as? UITextField)?.text ?? "" }
            .removeDuplicates()
            .debounce(for: .debounceDelta, scheduler: RunLoop.main)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.presenter.userDidWrite(query: $0) }
            .store(in: &subscribers)
    }
}

// MARK: - ISearchViewController

extension SearchViewController: ISearchViewController {

    func apply(snapshot: SearchDiffableDataSnapshot) {
        collectionViewDataSource.apply(snapshot, animatingDifferences: true)
    }

    func showSkeleton() {
        // collectionView.showSkeleton()
    }

    func hideSkeleton() {
        // collectionView.hideSkeleton(reloadDataAfter: false)
    }
}

// MARK: - SearchViewController

extension SearchViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.userDidSelect(index: indexPath.row, on: self)
    }
}
