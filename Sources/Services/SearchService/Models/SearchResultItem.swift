//
//  SearchResultItem.swift
//  Octotorp
//

import Foundation
import CoreLocation
import MapKit

struct SearchResult: Decodable {

    let items: [SearchResultItem]

    enum CodingKeys: String, CodingKey {
       case hits
   }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        items = try values.decode([SearchResultItem].self, forKey: .hits)
    }
}

struct SearchResultItem: Decodable {

    let name: String
    let coodinate: CLLocationCoordinate2D

    enum CodingKeys: String, CodingKey {
        case name
        case point
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)

        let point = try values.decode([String: Double].self, forKey: .point)
        coodinate = try CLLocationCoordinate2D(point: point)
    }
}
