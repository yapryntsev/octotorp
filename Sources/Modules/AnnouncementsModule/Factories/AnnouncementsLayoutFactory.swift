//
//  AnnouncementsLayoutFactory.swift
//  Octotorp
//

import Foundation

import UIKit

private extension CGFloat {
    static let estimatedSearchItemSize: CGFloat = 64
}

struct AnnouncementsLayoutFactory: ILayoutProvider {

    func layout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { _, environment in
            return createAnnouncementsSection()
        }
    }

    // MARK: - Private

    private func createAnnouncementsSection() -> NSCollectionLayoutSection? {

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(.estimatedSearchItemSize)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(.estimatedSearchItemSize)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = .compactSpace

        return section
    }
}
