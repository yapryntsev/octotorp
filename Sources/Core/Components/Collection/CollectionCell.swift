//
//  CollectionCell.swift
//  Octotorp
//

import UIKit
import SnapKit

public final class CollectionCell<T>: UICollectionViewCell,
    Configurable
where
    T: UIView,
    T: Configurable,
    T: Reusable {

    public private(set) lazy var wrappedView: T = {
        return T(frame: bounds)
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)

        isSkeletonable = true
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        contentView.addSubview(wrappedView)
        wrappedView.snp.makeConstraints {
            $0.edges.equalToSuperview().priority(.high)
        }
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Reusable

    public override func prepareForReuse() {
        super.prepareForReuse()
        wrappedView.prepareForReuse()
    }

    // MARK: - Configurable

    public func configure(with model: T.Model) {
        wrappedView.configure(with: model)
    }

    public override var isSelected: Bool {
        didSet {
            if let selectable = wrappedView as? Selectable {
                isSelected ? selectable.selected() : selectable.deselected()
            }
        }
    }

    public override var isHighlighted: Bool {
        didSet {
            if let highlightable = wrappedView as? Highlightable {
                isHighlighted ? highlightable.highlighted() : highlightable.unhighlighted()
            }
        }
    }
}
