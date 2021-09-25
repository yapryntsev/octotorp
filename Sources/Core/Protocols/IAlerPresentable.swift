//
//  IAlerPresentable.swift
//  Octotorp
//

import Foundation

protocol IAlertPresentable: AnyObject {
    func present(title: String, text: String)
}
