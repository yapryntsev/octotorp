//
//  SearchDataSource.swift
//  Octotorp
//

import UIKit
import SkeletonView

typealias SearchDiffableDataSnapshot = NSDiffableDataSourceSnapshot<SearchSection, SearchItemView.Model>
typealias SearchDiffableDataSource = UICollectionViewDiffableDataSource<SearchSection, SearchItemView.Model>

class SearchDataSource: SearchDiffableDataSource, SkeletonCollectionViewDataSource {

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
