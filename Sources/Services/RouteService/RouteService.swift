//
//  RouteService.swift
//  Octotorp
//

import MapKit
import PromiseKit
import Foundation

protocol IRouteService {
    func route(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D) -> Promise<[Route]>
}

final class RouteService: IRouteService {

    // Dependencies
    //private let poiService: IPointsOfInterestServiceService = PointsOfInterestServiceService()

    // MARK: - Public

    func route(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D) -> Promise<[Route]> {
        let rect = MKMapRect(coordinates: [start, end])
        return when(fulfilled: [
            buildRoute(start: start, throught: [], transport: .walking, end: end),
            buildRoute(start: start, throught: [], transport: .bike, end: end),
            buildRoute(start: start, throught: [], transport: .scooter, end: end)
        ])

//        return firstly {
//            poiService.poi(for: rect)
//        }.then { poi in
//            self.buildRoute(start: start, throught: poi.map(\.coordinate), end: end)
//        }
    }

    // MARK: - Private

    private func buildRoute(
        start: CLLocationCoordinate2D,
        throught: [CLLocationCoordinate2D],
        transport: Route.Transport,
        end: CLLocationCoordinate2D
    ) -> Promise<Route> {

        return Promise<Route> { seal in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                let path = Bundle.main.path(forResource: "response", ofType: "json")
                let data = FileManager.default.contents(atPath: path!)

                let decodedData = try? JSONDecoder().decode(RouteResponse.self, from: data!)
                seal.fulfill(decodedData!.paths.first!)
            }
        }
    }
}
