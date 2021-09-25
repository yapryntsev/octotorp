//
//  TextFieldsFactory.swift
//  Octotorp
//

import UIKit

private extension CGFloat {
    static let defaultHeigh = CGFloat(44)
}

final class TextFieldsFactory {

    public var plain: UITextField {
        let textField = UITextField()
        textField.cornerRadius(.baseRadius)
        textField.snp.makeConstraints {
            $0.height.equalTo(CGFloat.defaultHeigh)
        }
        return textField
    }
}
