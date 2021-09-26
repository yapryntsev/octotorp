//
//  MKHexagon.swift
//  Octotorp
//

import Foundation
import MapKit

final class MKHexagon: MKPolygon {

    convenience init(center: CLLocationCoordinate2D, radius: Double) {
        let radius = radius * 12
        let center = MKMapPoint(center)

        let sides: CGFloat = 6
        let theta = (CGFloat.pi * 2) / sides

        var points = [MKMapPoint]()

        let initialPoint = MKMapPoint(
            x: radius * cos(2 * CGFloat.pi * 0 / sides + theta) + center.x,
            y: radius * sin(2 * CGFloat.pi * 0 / sides + theta) + center.y
        )

        points.append(initialPoint)

        for i in 1...Int(sides) {
            let point = MKMapPoint(
                x: radius * cos(2 * CGFloat.pi * CGFloat(i) / sides + theta) + center.x,
                y: radius * sin(2 * CGFloat.pi * CGFloat(i) / sides + theta) + center.y
            )
            points.append(point)
        }

        self.init(points: points, count: points.count)
    }
}
