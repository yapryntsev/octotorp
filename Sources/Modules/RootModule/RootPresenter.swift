//
//  RootPresenter.swift
//  Octotorp
//

import UIKit

protocol IRootPresenter {
    func viewDidLoad()
}

final class RootPresenter: IRootPresenter {

    // Properties
    weak var view: IRootContainer?

    // MARK: - IRootPresenter

    func viewDidLoad() { }
}
