//
//  HubAssembly.swift
//  Octotorp
//

import UIKit

final class HubAssembly {

    func assemble(output: @escaping (HubWidgetType) -> Void) -> UIViewController {
        let presenter = presenter(output: output)
        let view = view(presenter: presenter)

        presenter.view = view
        return view
    }

    // MARK: - Private

    private func view(presenter: IHubPresenter) -> HubViewController {
        let layoutProvider = HubLayoutFactory()
        return HubViewController(presenetr: presenter, layoutProvider: layoutProvider)
    }

    private func presenter(output: @escaping (HubWidgetType) -> Void) -> HubPresenter {
        let snapshotFactory = HubSnapshotFactory()
        let recommendService = RecommendService()
        
        return HubPresenter(
            output: output,
            snapshotFactory: snapshotFactory,
            recommendService: recommendService
        )
    }
}
