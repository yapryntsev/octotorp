//
//  HealthSensor.swift
//  HealthSensor
//

import CoreLocation

struct HealthSensor: Decodable {
    let coordinate: CLLocationCoordinate2D
    let raiting: Int

    enum CodingKeys: String, CodingKey {
        case ecoRaiting
        case coordinate
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let raw = try values.decode([String: Double].self, forKey: .coordinate)

        raiting = try values.decode(Int.self, forKey: .ecoRaiting)
        coordinate = CLLocationCoordinate2D(latitude: raw["lat"]!, longitude: raw["long"]!)
    }
}
