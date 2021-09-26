//
//  MapHealthService.swift
//  Octotorp
//

import MapKit
import PromiseKit
import Foundation
import Alamofire

protocol IMapHealthService {
    func sensors(top: CLLocationCoordinate2D, bottom: CLLocationCoordinate2D) -> Promise<[HealthSensor]>
}

final class MapHealthService: IMapHealthService {

    // Models
    struct Parameters: Encodable {
        let leftBottomPoint: [String: Double]
        let rightTopPoint: [String: Double]
        let rightBottomPoint: [String: Double]
        let leftTopPoint: [String: Double]
    }

    // Properties
    private let endpoint = "http://147.182.188.69/sensors"

    // MARK: - Public

    func sensors(top: CLLocationCoordinate2D, bottom: CLLocationCoordinate2D) -> Promise<[HealthSensor]> {

        return Promise { seale in
            self.request(top: top, bottom: bottom).responseDecodable(of: [HealthSensor].self) { response in
                switch response.result {
                case .success(let result):
                    seale.fulfill(result)
                case .failure(let error):
                    seale.reject(error)
                }
            }
        }
    }

    // MARK: - Private

    private func request(top: CLLocationCoordinate2D, bottom: CLLocationCoordinate2D) -> DataRequest {
        let parameters = parameters(top: top, bottom: bottom)
        return AF.request(endpoint, method: .post, parameters: parameters)
    }

    private func parameters(top: CLLocationCoordinate2D, bottom: CLLocationCoordinate2D) -> Parameters {
        return .init(
            leftBottomPoint: [
                "latitude" : top.latitude,
                "longitude" : bottom.longitude
            ],
            rightTopPoint: [
                "latitude" : bottom.latitude,
                "longitude" : top.longitude
            ],
            rightBottomPoint: [
                "latitude" : bottom.latitude,
                "longitude" : bottom.longitude
            ],
            leftTopPoint: [
                "latitude" : top.latitude,
                "longitude" : top.longitude
            ]
        )
    }
}
