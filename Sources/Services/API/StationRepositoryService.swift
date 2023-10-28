//
//  StationRepositoryService.swift
//  KOLEO
//
//  Created by Adrian Bobrowski on 27/10/2023.
//

import Foundation

protocol StationRepositoryService {
    
    /// Delivers the array of Station asynchronously.
    /// - Returns: An asynchronously-delivered array of Station.
    func allStations() async throws -> [Station]
    
    /// Delivers the array of Keywords asynchronously.
    /// - Returns: An asynchronously-delivered array of Keywords.
    func allKeywords() async throws -> [StationKeyword]
}
