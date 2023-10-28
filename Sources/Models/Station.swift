//
//  Station.swift
//  KOLEO
//
//  Created by Adrian Bobrowski on 28/10/2023.
//

import CoreLocation

struct Station: Identifiable {
    
    let id: Int
    let name: String
    let location: CLLocation
    let hits: Int
    let city: String?
    let region: String?
    let country: String?
}

// MARK: - Equatable
extension Station: Equatable {
    
    static func == (lhs: Station, rhs: Station) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Comparable
extension Station: Comparable {
    
    static func < (lhs: Station, rhs: Station) -> Bool {
        lhs.hits < rhs.hits
    }
}

// MARK: - Utils
extension Station {
    
    /// Returns the distance  from the current object’s location to the secound station location.
    func distance(to station: Station) -> Measurement<UnitLength> {
        .init(value: station.location.distance(from: self.location), unit: .meters)
    }
}
