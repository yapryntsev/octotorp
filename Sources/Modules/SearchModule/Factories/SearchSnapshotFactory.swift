//
//  SearchSnapshotFactory.swift
//  Octotorp
//

import UIKit

protocol ISearchSnapshotFactory {
    func snapshot(for items: [SearchResultItem]) -> SearchDiffableDataSnapshot
}

final class SearchSnapshotFactory: ISearchSnapshotFactory {

    // MARK: - ISearchSnapshotFactory

    func snapshot(for items: [SearchResultItem]) -> SearchDiffableDataSnapshot {
        var snapshot = SearchDiffableDataSnapshot()
        let models = items
            .enumerated()
            .map { map($0) }

        snapshot.appendSections([.searchItems])
        snapshot.appendItems(models, toSection: .searchItems)

        return snapshot
    }

    // MARK: - Private

    private func map(_ tuple: (offset: Int, element: SearchResultItem)) -> SearchItemView.Model {
        let configuration = UIImage.SymbolConfiguration(weight: .semibold)
        let image = UIImage(systemName: "magnifyingglass", withConfiguration: configuration)
        return .init(index: tuple.offset, image: image, title: tuple.element.name)
    }
}
