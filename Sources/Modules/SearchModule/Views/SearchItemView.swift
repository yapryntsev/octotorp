//
//  SearchItemView.swift
//  Octotorp
//

import UIKit

typealias SearchItemCell = CollectionCell<SearchItemView>

private extension UIEdgeInsets {
    static let contentInset = UIEdgeInsets(horizontal: .zero, vertical: .tinySpace)
}

private extension CGSize {
    static let iconSize = CGSize(width: 32, height: 32)
}

private extension CGFloat {
    static let iconContetnInset = CGFloat(6)
}

final class SearchItemView: UIView {

    struct Model: Hashable {
        let index: Int
        
        let image: UIImage?
        let title: String
    }

    // UI
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = UIColor.styleGuide.primary
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var iconImageViewWrapper: UIView = {
        let wrapper = UIView()
        wrapper.cornerRadius(.largeRadius)
        wrapper.backgroundColor = UIColor.styleGuide.c200

        wrapper.addSubview(iconImageView)
        iconImageView.snp.edgesToSuperview(with: .init(all: .iconContetnInset))

        return wrapper
    }()
    private lazy var titleLabel: UILabel = {
        return UILabel.styleGuide.body1
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
            iconImageViewWrapper, titleLabel
        ], spacing: .normalSpace, axis: .horizontal)

        addSubview(wrapper)
        wrapper.snp.edgesToSuperview(with: .contentInset)

        iconImageViewWrapper.snp.makeConstraints { make in
            make.size.equalTo(CGSize.iconSize)
        }
    }
}

// MARK: - Configurable

extension SearchItemView: Configurable {

    func configure(with model: Model) {
        iconImageView.image = model.image
        titleLabel.text = model.title
    }
}

// MARK: - Reusable

extension SearchItemView: Reusable {

    func prepareForReuse() {
        titleLabel.text = nil
        iconImageView.image = nil
    }
}
