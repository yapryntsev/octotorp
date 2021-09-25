//
//  SearchAssembly.swift
//  Octotorp
//

import UIKit

final class SearchAssembly {

    // MARK: - Public

    func assemble(output: @escaping (SearchResultItem, UIViewController) -> Void) -> UIViewController {
        let presenter = presenter(output: output)
        let view = view(presenter: presenter)

        presenter.view = view
        return view
    }

    // MARK: - Private

    private func presenter(output: @escaping (SearchResultItem, UIViewController) -> Void) -> SearchPresenter {
        let searchService = SearchService()
        let snapshotFactory = SearchSnapshotFactory()
        return SearchPresenter(searchService: searchService, snapshotFactory: snapshotFactory, output: output)
    }

    private func view(presenter: ISearchPresenter) -> SearchViewController {
        let layoutProvider = SearchLayoutFactory()
        return SearchViewController(presenter: presenter, layoutProvider: layoutProvider)
    }
}
