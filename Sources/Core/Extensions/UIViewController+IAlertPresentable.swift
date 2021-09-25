//
//  UIViewController+IAlertPresentable.swift
//  Octotorp
//

import UIKit

private extension String {
    static let actionTitle = "Хорошо"
}

extension UIViewController: IAlertPresentable {

    func present(title: String, text: String) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)

        alert.addAction(.init(title: .actionTitle, style: .default, handler: { _ in
            self.dismiss(animated: true)
        }))

        self.present(alert, animated: true)
    }
}
