//
//  HubDataSource.swift
//  HubDataSource
//
//  Created by a.yapryntsev on 24.09.2021.
//

import UIKit
import SkeletonView

enum HubSection: Int, RawRepresentable {
    case search
    case routes
    case awards
}

struct HubItemModel: Hashable {
    let image: UIImage?
    let title: String?
    let subtitle: String?
}

typealias HubDiffableDataSnapshot = NSDiffableDataSourceSnapshot<HubSection, HubItemModel>
typealias HubDiffableDataSource = UICollectionViewDiffableDataSource<HubSection, HubItemModel>

class HubDataSource: HubDiffableDataSource, SkeletonCollectionViewDataSource {

    func collectionSkeletonView(
        _ skeletonView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return 4
    }

    func collectionSkeletonView(
        _ skeletonView: UICollectionView,
        cellIdentifierForItemAt indexPath: IndexPath
    ) -> ReusableCellIdentifier {
        return String(describing: SearchItemCell.self)
    }
}
