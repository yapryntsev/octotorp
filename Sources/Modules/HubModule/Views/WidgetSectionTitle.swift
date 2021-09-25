//
//  WidgetSectionTitle.swift
//  Octotorp
//

import UIKit

typealias WidgetSectionTitleCell = CollectionCell<WidgetSectionTitleView>

final class WidgetSectionTitleView: UIView {

    // UI
    private lazy var titleLabel: UILabel = {
        let label = UILabel.styleGuide.heading4
        return label
    }()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private

    private func setup() {
        addSubview(titleLabel)
        titleLabel.snp.edgesToSuperview()
    }
}

// MARK: - Configurable

extension WidgetSectionTitleView: Configurable {

    func configure(with model: String) {
        titleLabel.text = model
    }
}

// MARK: - Reusable

extension WidgetSectionTitleView: Reusable {

    func prepareForReuse() { }
}
