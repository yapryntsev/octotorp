//
//  RouteWidgetView.swift
//  Octotorp
//

import UIKit

typealias RouteWidgetCell = CollectionCell<RouteWidgetView>

private extension CGSize {
    static let iconSize = CGSize(width: 22, height: 22)
}

final class RouteWidgetView: UIView {

    // UI
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.styleGuide.c200
        imageView.cornerRadius(.baseRadius, mask: true)
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel.styleGuide.body1
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel.styleGuide.caption1
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

        let textWrapper = UIStackView(subviews: [
            titleLabel, subtitleLabel
        ], spacing: .zero, axis: .vertical)

        let wrapper = UIStackView(subviews: [
            imageView, textWrapper
        ], spacing: .compactSpace, axis: .vertical)

        imageView.snp.makeConstraints { make in
            make.height.equalTo(100)
        }

        addSubview(wrapper)
        wrapper.snp.edgesToSuperview()
    }
}

// MARK: - Configurable

extension RouteWidgetView: Configurable {

    func configure(with model: HubItemModel) {
        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle
        imageView.image = model.image
    }
}

// MARK: - Reusable

extension RouteWidgetView: Reusable {
    func prepareForReuse() { }
}
