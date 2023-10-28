//
//  StationKeywordDTO.swift
//  KOLEO
//
//  Created by Adrian Bobrowski on 27/10/2023.
//

import Foundation

struct StationKeywordDTO: Decodable, Identifiable {
    
    var id: Int
    var keyword: String
    var stationId: Int
}

extension StationKeywordDTO {
    
    /// Converts to a domain model
    /// - Returns: a domain model
    func toDomain() -> StationKeyword {
        .init(
            id: self.id,
            keyword: self.keyword,
            stationId: self.stationId
        )
    }
}
