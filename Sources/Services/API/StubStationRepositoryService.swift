//
//  StubStationRepositoryService.swift
//  KOLEO
//
//  Created by Adrian Bobrowski on 27/10/2023.
//

import Foundation

struct StubStationRepositoryService: StationRepositoryService {
    
    let stations: [Station]
    let keywords: [StationKeyword]
    
    func allStations() async throws -> [Station] {
        self.stations
    }
    
    func allKeywords() async throws -> [StationKeyword] {
        self.keywords
    }
}
