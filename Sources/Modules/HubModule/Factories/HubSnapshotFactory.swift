//
//  HubSnapshotFactory.swift
//  Octotorp
//

import UIKit

protocol IHubSnapshotFactory {
    func snapshot(for: [RecommendedRoute]) -> HubDiffableDataSnapshot
}

final class HubSnapshotFactory: IHubSnapshotFactory {

    // MARK: - ISearchSnapshotFactory

    func snapshot(for recommended: [RecommendedRoute]) -> HubDiffableDataSnapshot {
        var snapshot = HubDiffableDataSnapshot()
        snapshot.appendSections([.search, .routes])

        snapshot.appendItems([.init(
            image: nil,
            title: "Куда едем?",
            subtitle: nil
        )], toSection: .search)

        let hubModels = recommended.map { item -> HubItemModel in
            return .init(image: item.image, title: item.title, subtitle: item.subtitle)
        }
        snapshot.appendItems(hubModels, toSection: .routes)

        return snapshot
    }
}
