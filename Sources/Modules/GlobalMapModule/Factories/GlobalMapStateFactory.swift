//
//  GlobalMapStateFactory.swift
//  Octotorp
//

import MapKit

struct GlobalMapState {
    let mapType: MKMapType
    let pointOfInterestFilter: MKPointOfInterestFilter
    let showsUserLocation: Bool
    let showRouteReview: Bool
    let userTrackingMode: MKUserTrackingMode
    let isUserTrackingButtonVisible: Bool
    let isUserInteractionEnabled: Bool
    let route: Route?
}

protocol IGlobalMapStateFactory {
    func explore() -> GlobalMapState
    func skeleton() -> GlobalMapState
    func navigate(_ route: Route) -> GlobalMapState
    func review(_ route: Route) -> GlobalMapState
    func history(_ route: Route) -> GlobalMapState
}

final class GlobalMapStateFactory: IGlobalMapStateFactory {

    func explore() -> GlobalMapState {
        return .init(
            mapType: .mutedStandard,
            pointOfInterestFilter: .excludingAll,
            showsUserLocation: true,
            showRouteReview: false,
            userTrackingMode: .none,
            isUserTrackingButtonVisible: true,
            isUserInteractionEnabled: true,
            route: nil
        )
    }

    func skeleton() -> GlobalMapState {
        return .init(
            mapType: .mutedStandard,
            pointOfInterestFilter: .excludingAll,
            showsUserLocation: false,
            showRouteReview: false,
            userTrackingMode: .none,
            isUserTrackingButtonVisible: false,
            isUserInteractionEnabled: false,
            route: nil
        )
    }

    func navigate(_ route: Route) -> GlobalMapState {
        return .init(
            mapType: .mutedStandard,
            pointOfInterestFilter: .excludingAll,
            showsUserLocation: true,
            showRouteReview: false,
            userTrackingMode: .followWithHeading,
            isUserTrackingButtonVisible: true,
            isUserInteractionEnabled: true,
            route: route
        )
    }

    func review(_ route: Route) -> GlobalMapState {
        return .init(
            mapType: .mutedStandard,
            pointOfInterestFilter: .excludingAll,
            showsUserLocation: true,
            showRouteReview: true,
            userTrackingMode: MKUserTrackingMode.none,
            isUserTrackingButtonVisible: true,
            isUserInteractionEnabled: true,
            route: route
        )
    }

    func history(_ route: Route) -> GlobalMapState {
        return .init(
            mapType: .mutedStandard,
            pointOfInterestFilter: .excludingAll,
            showsUserLocation: false,
            showRouteReview: true,
            userTrackingMode: MKUserTrackingMode.none,
            isUserTrackingButtonVisible: false,
            isUserInteractionEnabled: false,
            route: route
        )
    }
}
