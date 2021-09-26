//
//  Sequence+TimesOfDay.swift
//  Octotorp
//

import Foundation

extension Sequence where Element == Cluster.Poi {

    func timesOfDay() -> [Cluster.Poi] {
        return self.map { item in
            guard item.type == .cafe else { return item }

            let components = Calendar.current.dateComponents([.hour], from: .now)
            guard let hour = components.hour else { return item }

            if hour >= 6 && hour < 12 {
                return item.mutate(weight: 0.1)
            }

            return item
        }
    }
}
