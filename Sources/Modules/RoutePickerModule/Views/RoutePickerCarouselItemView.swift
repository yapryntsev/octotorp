//
//  RoutePickerCarouselItemView.swift
//  Octotorp
//

import UIKit
import SkeletonView

typealias RoutePickerCarouselItemCell = CollectionCell<RoutePickerCarouselItemView>

private extension CGSize {
    static let iconSize = CGSize(width: 20, height: 20)
}

private extension UIEdgeInsets {
    static let contentInsets = UIEdgeInsets(horizontal: .normalSpace, vertical: .compactSpace)
}

final class RoutePickerCarouselItemView: UIView {

    // Models
    struct Model {
        let icon: UIImage?
        let text: String
    }

    // UI
    private lazy var transportTypeImageView: UIImageView = {
        let view = UIImageView()
        view.tintColor = UIColor.styleGuide.primary
        view.contentMode = .scaleAspectFit
        return view
    }()

    private lazy var timeIntervalLabel: UILabel = {
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

    // MARK: - Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutSkeletonIfNeeded()
        round(mask: true)
    }
    
    // MARK: - Private

    private func setup() {
        cornerRadius(.baseRadius, mask: true)

        let wrapper = UIStackView(subviews: [
            transportTypeImageView, timeIntervalLabel
        ], spacing: .smallSpace, axis: .horizontal)

        addSubview(wrapper)
        wrapper.snp.edgesToSuperview(with: .contentInsets)

        transportTypeImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize.iconSize)
        }

        self.isSkeletonable = true
    }
}

// MARK: - Configurable

extension RoutePickerCarouselItemView: Configurable {

    func configure(with model: Model) {
        timeIntervalLabel.text = model.text
        transportTypeImageView.image = model.icon
    }
}

// MARK: - Reusable

extension RoutePickerCarouselItemView: Reusable {

    func prepareForReuse() {
        transportTypeImageView.image = nil
        timeIntervalLabel.text = nil
    }
}

extension RoutePickerCarouselItemView: Selectable {

    func selected() {
        backgroundColor = UIColor.styleGuide.primaryLight
        transportTypeImageView.tintColor = UIColor.styleGuide.primary
        timeIntervalLabel.textColor = UIColor.styleGuide.primary
    }

    func deselected() {
        backgroundColor = .clear
        transportTypeImageView.tintColor = UIColor.styleGuide.c800
        timeIntervalLabel.textColor = UIColor.styleGuide.c800
    }
}
