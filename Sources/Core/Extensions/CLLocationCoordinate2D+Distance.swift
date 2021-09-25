//
//  CLLocationCoordinate2D+Distance.swift
//  Octotorp
//

import MapKit

extension CLLocationCoordinate2D {

    func distance(to: CLLocationCoordinate2D) -> CLLocationDistance {
        MKMapPoint(self).distance(to: MKMapPoint(to))
    }
}
