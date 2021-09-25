//
//  AnnouncementItemView.swift
//  Octotorp
//

import UIKit

typealias AnnouncementItemCell = CollectionCell<AnnouncementItemView>

private extension CGSize {
    static let directionImageViewSize = CGSize(width: 40, height: 40)
}

private extension CGFloat {
    static let cellHeight = CGFloat(112)
}

private extension UIEdgeInsets {
    static let contentInsets = UIEdgeInsets(horizontal: .expandedSpace, vertical: .zero)
}

final class AnnouncementItemView: UIView {

    struct Model: Hashable {
        let image: UIImage?
        let instruction: String
        let distance: String
    }

    // UI
    private lazy var directionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = UIColor.styleGuide.c1000
        imageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize.directionImageViewSize)
        }
        return imageView
    }()

    private lazy var distanceLabel: UILabel = {
        return UILabel.styleGuide.heading4
    }()

    private lazy var hintLabel: UILabel = {
        let label = UILabel.styleGuide.body1
        label.numberOfLines = 2
        label.textColor = UIColor.styleGuide.c600
        label.font = .systemFont(ofSize: 18, weight: .medium)
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
        let labelsWrapper = UIStackView(subviews: [
            hintLabel, distanceLabel
        ], spacing: .zero, axis: .vertical)

        let wrapper = UIStackView(subviews: [
            directionImageView, labelsWrapper
        ], spacing: .expandedSpace, axis: .horizontal)
        wrapper.alignment = .center

        addSubview(wrapper)
        wrapper.snp.edgesToSuperview(with: .contentInsets)

        snp.makeConstraints { make in
            make.height.equalTo(CGFloat.cellHeight)
        }
    }
}

// MARK: - Configurable

extension AnnouncementItemView: Configurable {

    func configure(with model: Model) {
        directionImageView.image = model.image
        hintLabel.text = model.instruction
        distanceLabel.text = model.distance
    }
}

// MARK: - Reusable

extension AnnouncementItemView: Reusable {

    func prepareForReuse() {
        directionImageView.image = nil
        hintLabel.text = nil
        distanceLabel.text = nil
    }
}
