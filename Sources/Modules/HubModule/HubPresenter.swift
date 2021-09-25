//
//  HubPresenter.swift
//  Octotorp
//

import UIKit

enum HubWidgetViewType {
    case search
    case award
    case route(Int)
}

enum HubWidgetType {
    case search
    case award
    case route(Route)
}

protocol IHubPresenter {
    func viewDidLoad()
    func userDidSelect(widget: HubWidgetViewType)
}

final class HubPresenter {

    // MARK: - Output
    private let output: (HubWidgetType) -> Void

    // Properties
    private var recommendedRoutes = [RecommendedRoute]()

    // Dependencies
    private let recommendService: IRecommendService
    private let snapshotFactory: IHubSnapshotFactory
    weak var view: IHubViewController?

    // MARK: - Initialization

    init(
        output: @escaping (HubWidgetType) -> Void,
        snapshotFactory: IHubSnapshotFactory,
        recommendService: IRecommendService
    ) {
        self.recommendService = recommendService
        self.snapshotFactory = snapshotFactory
        self.output = output
    }

    // MARK: - Private

    private func fetchData() {
        recommendService.recommendedRoutes()
            .done { [self] routes in
                recommendedRoutes = routes
                configureView()
            }
            .catch { [self] error in
                view?.present(title: "Ошибочка", text: error.localizedDescription)
            }
    }

    private func configureView() {
        let snapshot = snapshotFactory.snapshot(for: recommendedRoutes)
        view?.apply(snapshot: snapshot)
    }
}

// MARK: - IHubPresenter

extension HubPresenter: IHubPresenter {

    func viewDidLoad() {
        fetchData()
    }

    func userDidSelect(widget: HubWidgetViewType) {
        switch widget {
        case .search:
            output(.search)
        case .award:
            output(.award)
        case .route(let index):
            let route = recommendedRoutes[index].route
            output(.route(route))
        }
    }
}
