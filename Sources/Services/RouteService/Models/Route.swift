//
//  Route.swift
//  Octotorp
//

import MapKit
import Foundation

struct Route: Decodable {

    struct Step: Equatable {
        let start: CLLocationCoordinate2D
        let end: CLLocationCoordinate2D
        let polyline: MKPolyline

        let sign: Int
        let notice: String?
        let instruction: String
        let travelTime: TimeInterval
        let distance: CLLocationDistance

        static func == (lhs: Route.Step, rhs: Route.Step) -> Bool {
            return lhs.start.latitude == rhs.start.latitude
                && lhs.start.longitude == rhs.start.longitude
                && lhs.end.longitude == rhs.end.longitude
                && lhs.end.longitude == rhs.end.longitude
        }

        func mutate(with distance: CLLocationDistance) -> Self {
            return .init(
                start: self.start,
                end: self.end,
                polyline: self.polyline,
                sign: self.sign,
                notice: self.notice,
                instruction: self.instruction,
                travelTime: self.travelTime,
                distance: distance
            )
        }
    }

    enum Transport {
        case walking
        case scooter
        case bike
    }

    let steps: [Step]
    let polyline: MKPolyline

    let distance: CLLocationDistance
    let travelTime: TimeInterval
    let transport: Route.Transport

    enum CodingKeys: String, CodingKey {
        case instructions
        case distance
        case points
        case time
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        distance = try values.decode(Double.self, forKey: .distance)
        travelTime = try values.decode(Double.self, forKey: .time)

        let coordinates = try values.decode(CoordinatesResponse.self, forKey: .points)
        let instructions = try values.decode([InstructionsResponse].self, forKey: .instructions)

        steps = coordinates.coordinates.enumerated().map { item in
            let end = item.element.indices.contains(1) ? item.element[1] : item.element[0]
            return .init(
                start: item.element[0],
                end: end,
                polyline: .init(coordinates: item.element, count: item.element.count),
                sign: 1, // instructions[item.offset + 1].sign,
                notice: nil,
                instruction: "instructions[item.offset + 1].text",
                travelTime: 1, // instructions[item.offset].time,
                distance: 1 // instructions[item.offset].distance
            )
        }

        let flatCoordinates = coordinates.coordinates.flatMap { $0 }
        polyline = .init(coordinates: flatCoordinates, count: flatCoordinates.count)

        transport = .scooter
    }

    init() {
        steps = []
        polyline = .init()
        distance = 0
        travelTime = 0
        transport = .scooter
    }
}

struct InstructionsResponse: Decodable {
    let distance: Double
    let sign: Int
    let text: String
    let time: Double
}

struct CoordinatesResponse: Decodable {
    let coordinates: [[CLLocationCoordinate2D]]

    enum CodingKeys: String, CodingKey {
        case coordinates
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let raw = try values.decode([[Double]].self, forKey: .coordinates)

        var coordinates = [[CLLocationCoordinate2D]](
            repeating: [],
            count: Int(Double(Double(raw.count) / 2.0).rounded(.up))
        )

        raw.enumerated().forEach { item in
            let index: Int = item.offset / 2
            coordinates[index].append(.init(latitude: item.element[1], longitude: item.element[0]))
        }

        self.coordinates = coordinates
    }

}

struct RouteResponse: Decodable {
    let paths: [Route]
}
