//
//  SearchWidgetView.swift
//  Octotorp
//

import UIKit

typealias SearchWidgetCell = CollectionCell<SearchWidgetView>

private extension CGSize {
    static let iconSize = CGSize(width: 22, height: 22)
}

final class SearchWidgetView: UIView {

    // UI
    private lazy var searchIconImageView: UIImageView = {
        let configuration = UIImage.SymbolConfiguration(pointSize: 22, weight: .semibold)
        let image = UIImage(systemName: "magnifyingglass", withConfiguration: configuration)
        let imageView = UIImageView()

        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.styleGuide.primary

        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel.styleGuide.body1
        label.textColor = UIColor.styleGuide.c700
        label.font = .systemFont(ofSize: label.font.pointSize, weight: .medium)
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
        let wrapper = UIStackView(subviews: [
            searchIconImageView, titleLabel
        ], spacing: .smallSpace, axis: .horizontal)

        searchIconImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize.iconSize)
        }

        addSubview(wrapper)
        wrapper.snp.edgesToSuperview(with: .init(all: .normalSpace))

        backgroundColor = UIColor.styleGuide.c200
        cornerRadius(.normalSpace)
    }
}

// MARK: - Configurable

extension SearchWidgetView: Configurable {

    func configure(with model: HubItemModel) {
        titleLabel.text = model.title
    }
}

// MARK: - Reusable

extension SearchWidgetView: Reusable {

    func prepareForReuse() { }
}
