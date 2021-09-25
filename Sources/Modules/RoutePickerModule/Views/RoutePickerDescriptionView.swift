//
//  RoutePickerDescriptionView.swift
//  Octotorp
//

import UIKit
import SkeletonView

private extension CGSize {
    static let closeButtonSize = CGSize(width: 40, height: 40)
}

protocol IRoutePickerDescriptionActionHandler: AnyObject {
    func userDidTapCloseButton()
    func userDidTapFromButtom()
}

private extension String {
    static let toLabelText = "Откуда:"
}

final class RoutePickerDescriptionView: UIView {

    // Models
    struct Model {
        let from: String
        let to: String
    }

    // UI
    private lazy var fromLabel: UILabel = {
        let label = UILabel.styleGuide.heading4
        label.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(29)
        }
        return label
    }()

    private lazy var toLabel: UILabel = {
        let label = UILabel.styleGuide.body1
        label.textColor = UIColor.styleGuide.c700
        label.lastLineFillPercent = 90
        label.text = .toLabelText
        return label
    }()

    private lazy var closeButton: UIButton = {
        let button = UIButton.styleGuide.close
        button.addAction { [weak self] in
            self?.actionHandler?.userDidTapCloseButton()
        }
        return button
    }()

    private lazy var changeDepartureButton: UILabel = {
        // TODO: заменить на кнопку
        let label = UILabel.styleGuide.body1
        label.lastLineFillPercent = 100
        label.textColor = UIColor.styleGuide.primary
        label.text = .toLabelText
        return label
    }()

    // Dependencies
    weak var actionHandler: IRoutePickerDescriptionActionHandler?

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
        isSkeletonable = true

        let toWrapper = UIStackView(subviews: [
            toLabel, changeDepartureButton
        ], spacing: .tinySpace, axis: .horizontal)
        toWrapper.alignment = .leading

        toWrapper.isSkeletonable = true

        let labelsWrapper = UIStackView(subviews: [
            fromLabel, toWrapper
        ], spacing: .smallSpace, axis: .vertical)

        [labelsWrapper, closeButton].forEach {
            addSubview($0)
        }

        labelsWrapper.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().inset(CGFloat.expandedSpace)
        }

        closeButton.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview().inset(CGFloat.expandedSpace)
            make.leading.greaterThanOrEqualTo(labelsWrapper.snp.trailing).offset(CGFloat.normalSpace)
            make.size.equalTo(CGSize.closeButtonSize)
        }

        [toWrapper, labelsWrapper].forEach {
            $0.isSkeletonable = true
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        closeButton.round(mask: true)
    }
}

// MARK: - Configurable

extension RoutePickerDescriptionView: Configurable {

    func configure(with model: Model) {
        fromLabel.text = model.from
        changeDepartureButton.text = model.to
    }
}
