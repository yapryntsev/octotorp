//
//  UICollectionView+Init.swift
//  Octotorp
//

import UIKit

extension UICollectionView {

    convenience init(layout: UICollectionViewLayout) {
        self.init(frame: .zero, collectionViewLayout: layout)
    }

    convenience init(layoutProvider: ILayoutProvider) {
        let layout = layoutProvider.layout()
        self.init(layout: layout)
    }
}
