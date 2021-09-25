//
//  RoutePickerCarouselLayoutFactory.swift
//  Octotorp
//

import UIKit

private extension CGFloat {
    static let estimatedSearchItemSize: CGFloat = 40
}

struct RoutePickerCarouselLayoutFactory: ILayoutProvider {

    func layout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { _, environment in
            return createSearchResultSection()
        }
    }

    // MARK: - Private

    private func createSearchResultSection() -> NSCollectionLayoutSection? {

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(.estimatedSearchItemSize),
            heightDimension: .estimated(.estimatedSearchItemSize)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(.estimatedSearchItemSize),
            heightDimension: .estimated(.estimatedSearchItemSize)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = .smallSpace
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(horizontal: .expandedSpace, vertical: .zero)

        return section
    }
}
