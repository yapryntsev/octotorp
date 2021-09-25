//
//  RootAssembly.swift
//  Octotorp
//

import UIKit

final class RootAssembly {

    func assemble(map: IGloblMapView) -> IRootContainer {
        let presenter = presenter()
        let view = view(map: map, presenter: presenter)

        presenter.view = view
        return view
    }

    // MARK: - Private

    private func view(map: IGloblMapView, presenter: IRootPresenter) -> RootViewController {
        return RootViewController(map: map, presenter: presenter)
    }

    private func presenter() -> RootPresenter {
        return RootPresenter()
    }
}
