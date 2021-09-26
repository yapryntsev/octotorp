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

    enum Transport: String, RawRepresentable {
        case walking
        case scooter
        case bike

        var request: String {
            switch self {
            case .walking:
                return "foot"
            case .scooter:
                return "scooter"
            case .bike:
                return "bike"
            }
        }
    }

    let steps: [Step]
    let polyline: MKPolyline

    let distance: CLLocationDistance
    let travelTime: TimeInterval
    var transport: Route.Transport

    enum CodingKeys: String, CodingKey {
        case instructions
        case distance
        case points
        case time
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        distance = try values.decode(Double.self, forKey: .distance)
        travelTime = try values.decode(Double.self, forKey: .time) / 1000

        let coordinates = try values.decode(CoordinatesResponse.self, forKey: .points).coordinates
        let instructions = try values.decode([InstructionsResponse].self, forKey: .instructions)


        steps = instructions.map { instruction -> Step in
            let slice = Array(coordinates[instruction.interval[0]...instruction.interval[1]])
            return .init(
                start: coordinates[instruction.interval[0]],
                end: coordinates[instruction.interval[1]],
                polyline: .init(coordinates: slice, count: slice.count),
                sign: instruction.sign,
                notice: nil,
                instruction: instruction.text,
                travelTime: instruction.time,
                distance: instruction.distance
            )
        }

        polyline = .init(coordinates: coordinates, count: coordinates.count)
        transport = .bike
    }
}

struct InstructionsResponse: Decodable {
    let distance: Double
    let sign: Int
    let text: String
    let time: Double
    let interval: [Int]
}

struct CoordinatesResponse: Decodable {
    let coordinates: [CLLocationCoordinate2D]

    enum CodingKeys: String, CodingKey {
        case coordinates
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let raw = try values.decode([[Double]].self, forKey: .coordinates)

        coordinates =  raw.map { item in
            return .init(latitude: item[1], longitude: item[0])
        }
    }

}

struct RouteResponse: Decodable {
    let paths: [Route]
}
