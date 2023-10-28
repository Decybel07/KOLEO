//
//  ApiStationRepositoryService.swift
//  KOLEO
//
//  Created by Adrian Bobrowski on 27/10/2023.
//

import Foundation

struct ApiStationRepositoryService: StationRepositoryService {
    
    let networkService: NetworkService
    
    func allStations() async throws -> [Station] {
        try await (self.fetch(url: "https://koleo.pl/api/v2/main/stations") as [StationDTO])
            .compactMap { $0.toDomain() }
    }
    
    func allKeywords() async throws -> [StationKeyword] {
        try await (self.fetch(url: "https://koleo.pl/api/v2/main/station_keywords") as [StationKeywordDTO])
            .map { $0.toDomain() }
    }
}

private extension ApiStationRepositoryService {
    
    private static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    func fetch<Output: Decodable>(url: String) async throws -> Output {
        try await Self.decoder.decode(
            Output.self,
            from: self.networkService.data(url: url, headers: [
                "X-KOLEO-Version": "1",
                "X-KOLEO-Client": "iOS-100",
                "User-Agent": "AdrianBobrowski/1.0.0",
            ])
        )
    }
}
