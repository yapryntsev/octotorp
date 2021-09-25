//
//  UICollectionView+Register.swift
//  Octotorp
//

import UIKit

extension UICollectionView {

    public func register<T: UICollectionViewCell>(_ cell: T.Type) {
        let identifier = String(describing: T.self)
        register(cell, forCellWithReuseIdentifier: identifier)
    }

    public func register<T: UICollectionReusableView>(_ supplementary: T.Type, of kind: String) {
        let identifier = String(describing: T.self)
        register(supplementary, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
    }

    public func dequeueSupplementary<T: UICollectionReusableView>(kind: String, for indexPath: IndexPath) -> T {
        let identifier = String(describing: T.self)
        guard let supplementary = dequeueReusableSupplementaryView(
                ofKind: kind, withReuseIdentifier: identifier, for: indexPath) as? T
        else {
            fatalError("Could not dequeue supplementary view with identifier: \(identifier) and kind: \(kind)")
        }
        return supplementary
    }

    public func dequeueCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        let identifier = String(describing: T.self)
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(identifier)")
        }

        return cell
    }
}
