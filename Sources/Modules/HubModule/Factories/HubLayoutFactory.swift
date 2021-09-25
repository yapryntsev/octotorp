//
//  HubLayoutFactory.swift
//  Octotorp
//

import UIKit

private extension CGFloat {
    static let estimatedSearchItemSize: CGFloat = 64
}

struct HubLayoutFactory: ILayoutProvider {

    func layout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { index, environment in
            guard let section = HubSection(rawValue: index) else { fatalError() }

            switch section {
            case .search:
                return createSearchResultSection()
            case .routes:
                return createRoutesSection()
            case .awards:
                break
            }

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
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(
            top: .normalSpace,
            leading: .expandedSpace,
            bottom: .largeSpace,
            trailing: .expandedSpace
        )

        return section
    }

    private func createRoutesSection() -> NSCollectionLayoutSection? {

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(.estimatedSearchItemSize)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.42),
            heightDimension: .absolute(148)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = .compactSpace
        section.contentInsets = .init(horizontal: .expandedSpace, vertical: .compactSpace)

        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(10)
        )
        section.boundarySupplementaryItems = [
            .init(
                layoutSize: headerSize,
                elementKind: ElementKind.sectionHeader,
                alignment: .top
            )
        ]

        return section
    }
}
