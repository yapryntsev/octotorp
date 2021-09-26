//
//  ClusterService.swift
//  Octotorp
//

import Foundation
import CoreLocation
import Alamofire
import PromiseKit

final class ClusterService {

    // Models
    struct Parameters: Encodable {
        let leftBottomPoint: [String: Double]
        let rightTopPoint: [String: Double]
        let rightBottomPoint: [String: Double]
        let leftTopPoint: [String: Double]
    }

    // Properties
    private let endpoint = "http://147.182.188.69/cluster"

    // MARK: - Public

    func cluster(top: CLLocationCoordinate2D, bottom: CLLocationCoordinate2D) -> Promise<[Cluster]> {

        return Promise { seale in
            self.request(top: top, bottom: bottom).responseDecodable(of: [Cluster].self) { response in
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
                "latitude" : 55.659214,
                "longitude" : 37.611780
            ],
            rightTopPoint: [
                "latitude" : 55.668267,
                "longitude" : 37.582297
            ],
            rightBottomPoint: [
                "latitude" : 55.672769,
                "longitude" : 37.611780
            ],
            leftTopPoint: [
                "latitude" : 55.659214,
                "longitude" : 37.582297
            ]
        )
//        return .init(
//            leftBottomPoint: [
//                "latitude" : bottom.latitude,
//                "longitude" : top.longitude
//            ],
//            rightTopPoint: [
//                "latitude" : top.latitude,
//                "longitude" : bottom.longitude
//            ],
//            rightBottomPoint: [
//                "latitude" : bottom.latitude,
//                "longitude" : bottom.longitude
//            ],
//            leftTopPoint: [
//                "latitude" : top.latitude,
//                "longitude" : top.longitude
//            ]
//        )
    }
}
