//
//  CollectionSupplementary.swift
//  Octotorp
//

import UIKit

public final class CollectionSupplementary<T>: UICollectionReusableView,
    Configurable
where
    T: UIView,
    T: Configurable,
    T: Reusable {

    public private(set) lazy var containedView: T = {
        return T(frame: bounds)
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(containedView)
        containedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Reusable

    public override func prepareForReuse() {
        super.prepareForReuse()
        containedView.prepareForReuse()
    }

    // MARK: - Configurable

    public func configure(with model: T.Model) {
        containedView.configure(with: model)
    }
}
