//
//  SearchService.swift
//  Octotorp
//

import Foundation
import Alamofire
import PromiseKit

protocol ISearchService {
    func find(query: String) -> Promise<[SearchResultItem]>
}

private extension String {
    static let bbox = "36.666870,55.266598,38.660889,56.325675"
}

final class SearchService: ISearchService {

    // Models
    struct Parameters: Encodable {
        let q: String
        let bbox: String
        let debug: Bool
        let key: String
    }

    // Properties
    private let endpoint = "https://graphhopper.com/api/1/geocode"
    private let encoder = URLEncodedFormParameterEncoder.default

    func find(query: String) -> Promise<[SearchResultItem]> {

        return Promise { seale in
            self.request(for: query).responseDecodable(of: SearchResult.self) { response in
                switch response.result {
                case .success(let result):
                    seale.fulfill(result.items)
                case .failure(let error):
                    seale.reject(error)
                }
            }
        }
    }

    // MARK: - Private

    private func request(for query: String) -> DataRequest {
        let parameters = parameters(for: query)
        return AF.request(endpoint, method: .get, parameters: parameters, encoder: encoder)
    }

    private func parameters(for query: String) -> Parameters {
        return .init(
            q: query,
            bbox: .bbox,
            debug: true,
            key: .graphhopperKey)
    }
}
