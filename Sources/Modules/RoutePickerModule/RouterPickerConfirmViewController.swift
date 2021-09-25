//
//  RouterPickerConfirmViewController.swift
//  Octotorp
//

import UIKit

private extension CGFloat {
    static let buttonHeight = CGFloat(52)
}

protocol IRouterPickerConfirmActionHandler: AnyObject {
    func userDidTapConfirmButton()
}

final class RouterPickerConfirmViewController: UIViewController {

    // UI
    private lazy var actionButton: UIButton = {
        let button = UIButton.styleGuide.filled
        button.configuration?.title = "Начать"
        button.addAction { [weak self] in
            self?.actionHandler?.userDidTapConfirmButton()
        }
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    // Dependencies
    private weak var actionHandler: IRouterPickerConfirmActionHandler?

    // MARK: - Initialization

    init(actionHandler: IRouterPickerConfirmActionHandler) {
        self.actionHandler = actionHandler
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private

    private func setup() {
        view.addSubview(actionButton)
        actionButton.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(CGFloat.expandedSpace)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(CGFloat.smallSpace)
            make.height.equalTo(CGFloat.buttonHeight)
        }
    }
}
