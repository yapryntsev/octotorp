//
//  Sequence+Health.swift
//  Octotorp
//

import Foundation
import CoreLocation

extension Sequence where Element == Cluster.Poi {

    func health(index: Double, coordinate: CLLocationCoordinate2D) -> [Cluster.Poi] {
        return self.map { item in
            let index = index * 0.01
            let delta = item.coordinate.distance(to: coordinate) * 0.0001
            return item.mutate(weight: index - delta)
        }
    }
}
