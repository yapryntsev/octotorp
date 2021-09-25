//
//  GlobalMapAssembly.swift
//  Octotorp
//

import UIKit

final class GlobalMapAssembly {

    func assemble() -> IGloblMapView {
        let presenter = presenter()
        let view = view(presenter: presenter)

        presenter.view = view
        return view
    }

    // MARK: - Private

    private func view(presenter: IGlobalMapPresenter) -> GlobalMapViewController {
        return GlobalMapViewController(presenter: presenter)
    }

    private func presenter() -> GlobalMapPresenter {
        let stateFactory = GlobalMapStateFactory()
        return GlobalMapPresenter(stateFactory: stateFactory)
    }
}
