//
//  CLLocationCoordinate2D+Init.swift
//  Octotorp
//

import CoreLocation

extension CLLocationCoordinate2D {

    // Инициализатор для ответа от graphhopper
    init(point: [String: Double]) throws {
        guard let latitude = point["lat"], let longitude = point["lng"] else { throw NSError.default }
        self.init(latitude: latitude, longitude: longitude)
    }
}
