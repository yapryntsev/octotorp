//
//  MKMapRect+Init.swift
//  Octotorp
//

import MapKit

extension MKMapRect {

    init(center: MKMapPoint, size: MKMapSize) {
        let origin = MKMapPoint(
            x: center.x - abs(size.width / 2),
            y: center.y - abs(size.height / 2)
        )
        self.init(origin: origin, size: size)
    }

    init(center: CLLocationCoordinate2D, size: MKMapSize) {
        self.init(center: .init(center), size: size)
    }

    init(coordinates: [CLLocationCoordinate2D]) {
        self = coordinates
            .map { MKMapPoint($0) }
            .map { MKMapRect(origin: $0, size: .init(width: .zero, height: .zero)) }
            .reduce(MKMapRect.null, { $0.union($1) })
    }
}
