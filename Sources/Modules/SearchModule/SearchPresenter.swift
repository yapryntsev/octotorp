//
//  SearchPresenter.swift
//  Octotorp
//

import UIKit

protocol ISearchPresenter {
    func viewDidLoad()

    func userDidWrite(query: String)
    func userDidSelect(index: Int, on controller: UIViewController)
}

final class SearchPresenter {

    // MARK: - Output
    private let output: (SearchResultItem, UIViewController) -> Void

    // Properties
    private var storage = [SearchResultItem]()

    // Dependencies
    private let snapshotFactory: ISearchSnapshotFactory
    private let searchService: ISearchService

    weak var view: ISearchViewController?

    // MARK: - Initialization

    init(
        searchService: ISearchService,
        snapshotFactory: ISearchSnapshotFactory,
        output: @escaping (SearchResultItem, UIViewController) -> Void
    ) {
        self.snapshotFactory = snapshotFactory
        self.searchService = searchService
        self.output = output
    }

    // MARK: - Private

    private func makeRequest(with query: String) {
        searchService.find(query: query).done { [self] items in
            storage = items
            updateView(with: items)
        }.catch { [self] in
            view?.present(title: "Ошибочка", text: $0.localizedDescription)
        }
    }

    private func updateView(with items: [SearchResultItem]) {
        let snapshot = snapshotFactory.snapshot(for: items)
        view?.apply(snapshot: snapshot)
        view?.hideSkeleton()
    }
}

// MARK: - ISearchPresenter

extension SearchPresenter: ISearchPresenter {

    func viewDidLoad() { }

    func userDidSelect(index: Int, on controller: UIViewController) {
        output(storage[index], controller)
    }

    func userDidWrite(query: String) {
        guard !query.isEmpty else {
            // TODO: показать недавние запросы
            return
        }
        view?.showSkeleton()
        makeRequest(with: query)
    }
}
