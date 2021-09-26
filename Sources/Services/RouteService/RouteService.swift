//
//  RouteService.swift
//  Octotorp
//

import MapKit
import PromiseKit
import Foundation
import Alamofire

protocol IRouteService {
    func route(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D) -> Promise<[Route]>
}

final class RouteService: IRouteService {

    // Dependencies
    private let clusterService = ClusterService()

    // Models
    struct Parameters: Encodable {
        let locale = "ru"
        let calc_points = true
        let key: String
    }

    // Properties
    private let endpoint = "https://graphhopper.com/api/1/route"
    private let encoder = URLEncoding(arrayEncoding: .noBrackets)

    // MARK: - Public

    func route(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D) -> Promise<[Route]> {

        return firstly {
            poi(start: start, end: end)
        }.flatMapValues { result in
            return Array(result.optimized.prefix(2))
        }.mapValues { poi in
            return poi.coordinate
        }.then { coordinates ->  Promise<[Route]> in
            when(fulfilled: [
                self.buildRoute(start: start, throught: coordinates, transport: .walking, end: end),
                self.buildRoute(start: start, throught: coordinates, transport: .bike, end: end),
                self.buildRoute(start: start, throught: coordinates, transport: .scooter, end: end)
            ])
        }

    }

    // MARK: - Private

    private func poi(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D) -> Promise<[Cluster]> {
        let left = min(start.longitude, end.longitude)
        let right = max(start.longitude, end.longitude)
        let top = max(start.latitude, end.latitude)
        let botom = min(start.latitude, end.latitude)

        return clusterService.cluster(
            top: .init(latitude: top, longitude: left),
            bottom: .init(latitude: botom, longitude: right)
        )
    }

    private func buildRoute(
        start: CLLocationCoordinate2D,
        throught: [CLLocationCoordinate2D],
        transport: Route.Transport,
        end: CLLocationCoordinate2D
    ) -> Promise<Route> {

        return Promise { seale in
            self.request(start: start, throught: throught, transport: transport, end: end)
                .responseDecodable(of: RouteResponse.self) { response in
                    switch response.result {
                    case .success(let result):
                        var route = result.paths.first!
                        route.transport = transport

                        seale.fulfill(route)
                    case .failure(let error):
                        seale.reject(error)
                    }
                }
        }
    }

    private func request(
        start: CLLocationCoordinate2D,
        throught: [CLLocationCoordinate2D],
        transport: Route.Transport,
        end: CLLocationCoordinate2D
    ) -> DataRequest {

        let throught = throught.map {
            return "\($0.latitude), \($0.longitude)"
        }

        // Учитывайте, что graphhopper не построит маршрут более чем через 3 точки на бесплатном
        // тарифе
        var points = ["\(end.latitude), \(end.longitude)", "\(start.latitude), \(start.longitude)"]
        points.append(contentsOf: throught)

        let parameters: [String: [String]] = [
            "point": points,
            "vehicle": [transport.request],
            "locale": ["ru"],
            "key": [.graphhopperKey],
            "instructions": ["true"],
            "points_encoded": ["false"],
            "calc_points": ["true"],
            "optimize": ["true"]
        ]

        return AF.request(endpoint, method: .get, parameters: parameters, encoding: encoder)
    }
}
