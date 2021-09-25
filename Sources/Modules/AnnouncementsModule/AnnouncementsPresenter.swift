//
//  AnnouncementsPresenter.swift
//  Octotorp
//

import UIKit

protocol IAnnouncementsPresenter {
    func viewDidAppear()
}

final class AnnouncementsPresenter {

    // Dependencies
    private weak var map: IGloblMapView?
    private let mapStateFactory: IGlobalMapStateFactory
    private let navigatorFacade: IRouteNavigationFacade
    private let viewModelFactory: IAnnouncementViewModelFactory

    init(
        map: IGloblMapView?,
        navigatorFacade: IRouteNavigationFacade,
        viewModelFactory: IAnnouncementViewModelFactory,
        mapStateFactory: IGlobalMapStateFactory
    ) {
        self.map = map
        self.navigatorFacade = navigatorFacade
        self.mapStateFactory = mapStateFactory
        self.viewModelFactory = viewModelFactory
    }
}

// MARK: - AnnouncementsPresenter

extension AnnouncementsPresenter: IAnnouncementsPresenter {

    func viewDidAppear() {
        navigatorFacade.navigate()

        let state = mapStateFactory.navigate(navigatorFacade.route)
        map?.configure(with: state)
    }
}
