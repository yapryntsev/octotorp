//
//  SearchLayoutFactory.swift
//  Octotorp
//
//  Created by a.yapryntsev on 24.09.2021.
//

import UIKit

private extension CGFloat {
    static let estimatedSearchItemSize: CGFloat = 32
}

struct SearchLayoutFactory: ILayoutProvider {

    func layout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { _, environment in
            return createSearchResultSection()
        }
    }

    // MARK: - Private

    private func createSearchResultSection() -> NSCollectionLayoutSection? {

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
