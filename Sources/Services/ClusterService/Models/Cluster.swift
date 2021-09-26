//
//  Cluster.swift
//  Octotorp
//

import Foundation
import CoreLocation

struct Cluster: Decodable {

    struct Poi: Decodable {

        enum Category: String, RawRepresentable {
            case cafe
        }

        let type: Category
        let coordinate: CLLocationCoordinate2D
        let weight: Double

        enum CodingKeys: String, CodingKey {
            case poiType
            case lon
            case lat
        }

        func mutate(weight: Double) -> Self {
            return .init(
                type: self.type,
                coordinate: self.coordinate,
                weight: self.weight + weight
            )
        }

        init(type: Category, coordinate: CLLocationCoordinate2D, weight: Double) {
            self.type = type
            self.coordinate = coordinate
            self.weight = weight
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)

            let rawType = try values.decode(String.self, forKey: .poiType)
            guard let type = Category(rawValue: rawType) else { throw NSError.default }
            self.type = type

            let lon = try values.decode(Double.self, forKey: .lon)
            let lat = try values.decode(Double.self, forKey: .lat)
            coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)

            weight = 0
        }
    }

    let poi: [Poi]
    let raiting: Double
    let coordinate: CLLocationCoordinate2D

    enum CodingKeys: String, CodingKey {
        case coordinate
        case ecoRaiting
        case pois
    }

    // MARK: - Initialization

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        poi = try values.decode([Poi].self, forKey: .pois)
        raiting = try values.decode(Double.self, forKey: .ecoRaiting)

        let raw = try values.decode([String: Double].self, forKey: .coordinate)
        coordinate = CLLocationCoordinate2D(
            latitude: raw["lantitude"]!,
            longitude: raw["longitude"]!
        )
    }

    // MARK: - Public

    var optimized: [Cluster.Poi] {
        return poi
            .health(index: raiting, coordinate: coordinate)
            .timesOfDay()
            .sorted(by: { $0.weight >= $1.weight })
    }
}
