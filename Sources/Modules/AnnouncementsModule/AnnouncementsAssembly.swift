//
//  AnnouncementsAssembly.swift
//  Octotorp
//

import UIKit

final class AnnouncementsAssembly {

    func assemble(route: Route, output: IRootWidgetContainer?) -> UIViewController {
        let navigationFacade = navigationFacade(for: route)
        
        let presenter = presenter(map: output?.map, navigationFacade: navigationFacade)
        let view = view(
            output: output,
            presenter: presenter,
            announcementsProvider: navigationFacade.announcer)

        navigationFacade.announcer.collectionView = view.collectionView

        return view
    }

    // MARK: - Private

    private func navigationFacade(for route: Route) -> RouteNavigationFacade {
        return RouteNavigationFacade(route: route)
    }

    private func view(
        output: IRootWidgetContainer?,
        presenter: AnnouncementsPresenter,
        announcementsProvider: IAnnouncementsProvider
    ) -> AnnouncementsViewController {

        return AnnouncementsViewController(
            output: output,
            presenter: presenter,
            announcementsProvider: announcementsProvider
        )
    }

    private func presenter(
        map: IGloblMapView?,
        navigationFacade: IRouteNavigationFacade
    ) -> AnnouncementsPresenter {

        let viewModelFactory = AnnouncementViewModelFactory()
        let mapStateFactory = GlobalMapStateFactory()

        return AnnouncementsPresenter(
            map: map,
            navigatorFacade: navigationFacade,
            viewModelFactory: viewModelFactory,
            mapStateFactory: mapStateFactory
        )
    }
}
