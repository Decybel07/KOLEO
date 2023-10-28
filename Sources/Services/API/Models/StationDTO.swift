//
//  StationDTO.swift
//  KOLEO
//
//  Created by Adrian Bobrowski on 27/10/2023.
//

import Foundation

struct StationDTO: Decodable, Identifiable {
    
    let id: Int
    let name: String
    let nameSlug: String
    let latitude: Double?
    let longitude: Double?
    let hits: Int
    let ibnr: Int?
    let city: String
    let region: String
    let country: String
    let localisedName: String?
    let isGroup: Bool
    let hasAnnouncements: Bool
}

extension StationDTO {
    
    /// Converts to a domain model
    /// - Returns: a domain model
    func toDomain() -> Station? {
        guard let latitude = self.latitude, let longitude = self.longitude else {
            return nil
        }
        return .init(
            id: self.id,
            name: self.localisedName ?? self.name,
            location: .init(latitude: latitude, longitude: longitude),
            hits: self.hits,
            city: self.city.isEmpty ? nil : self.city,
            region: self.region.isEmpty ? nil : self.region,
            country: self.country.isEmpty ? nil : self.country
        )
    }
}
