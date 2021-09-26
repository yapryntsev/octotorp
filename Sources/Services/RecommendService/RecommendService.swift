//
//  RecommendService.swift
//  Octotorp
//

import Foundation
import PromiseKit
import UIKit

protocol IRecommendService {
    func recommendedRoutes() -> Promise<[RecommendedRoute]>
}

final class RecommendService: IRecommendService {

    func recommendedRoutes() -> Promise<[RecommendedRoute]> {
        return Promise {
            $0.fulfill(getMocks())
        }
    }

    // MARK: - Private

    private func getMocks() -> [RecommendedRoute] {
        let additionalInfo = [
            (title: "Прогулки в лесу", subtitle: "Битцевский лес", image: UIImage(named: "BIZ")),
            (title: "Москва с высоты", subtitle: "Воробьевы горы", image: UIImage(named: "MSU"))
        ]

        let item: [RecommendedRoute] = (1...2)
            .compactMap { index -> String? in
                return Bundle.main.path(forResource: "route_0\(index)", ofType: "json")
            }
            .compactMap { path -> Data? in
                return FileManager.default.contents(atPath: path)
            }
            .compactMap { data in
                return try? JSONDecoder().decode(RouteResponse.self, from: data)
            }
            .enumerated()
            .map { tuple -> RecommendedRoute in
                let info = additionalInfo[tuple.offset]
                return .init(
                    title: info.title,
                    subtitle: info.subtitle,
                    image: info.image,
                    route: tuple.element.paths.first!
                )
            }

        return item
    }
}
