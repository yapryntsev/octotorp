//
//  RoutePickerViewController.swift
//  Octotorp
//

import UIKit
import SkeletonView

protocol IRoutePickerViewController: IAlertPresentable {
    func configure(with model: RoutePickerViewController.Model)
    func showSkeleton()
    func hideSkeleton()
}

final class RoutePickerViewController: UIViewController {

    // Models
    struct Model {
        let descriptionModel: RoutePickerDescriptionView.Model
        let carouselModel: [RoutePickerCarouselItemView.Model]
    }

    // UI
    private lazy var descriptionView: RoutePickerDescriptionView = {
        let view = RoutePickerDescriptionView()
        view.actionHandler = self
        return view
    }()

    private lazy var carouselView: RoutePickerCarouselView = {
        let view = RoutePickerCarouselView()
        view.actionHandler = self
        return view
    }()

    // Dependencies
    private let presenter: IRoutePickerPresenter

    // MARK: - Initialization

    init(presenter: IRoutePickerPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        setup()
        super.viewDidLoad()
        presenter.viewDidLoad()
    }

    // MARK: - Private

    private func setup() {
        let wrapper = UIStackView(subviews: [
            descriptionView, carouselView
        ], spacing: .expandedSpace, axis: .vertical)

        view.addSubview(wrapper)
        wrapper.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(CGFloat.normalSpace)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(CGFloat.expandedSpace)
        }

        [view, wrapper].forEach {
            $0.isSkeletonable = true
        }
    }
}

// MARK: - IRoutePickerViewController

extension RoutePickerViewController: IRoutePickerViewController {

    func showSkeleton() {
        view.showAnimatedSkeleton()
    }

    func hideSkeleton() {
        view.hideSkeleton(reloadDataAfter: true)
    }
}

// MARK: - Configurable

extension RoutePickerViewController: Configurable {

    func configure(with model: Model) {
        descriptionView.configure(with: model.descriptionModel)
        carouselView.configure(with: model.carouselModel)
    }
}

// MARK: - IRoutePickerDescriptionActionHandler

extension RoutePickerViewController: IRoutePickerDescriptionActionHandler {

    func userDidTapCloseButton() {
        presenter.userDidTapCloseButton()
    }

    func userDidTapFromButtom() {
        presenter.userDidTapFromButtom()
    }
}

// MARK: - IRoutePickerCarouselActionHandler

extension RoutePickerViewController: IRoutePickerCarouselActionHandler {

    func userDidSelectType(index: Int) {
        presenter.userDidSelectType(index: index)
    }
}
