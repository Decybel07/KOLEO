//
//  StationTests.swift
//  KOLEOTests
//
//  Created by Adrian Bobrowski on 28/10/2023.
//

import XCTest
@testable import KOLEO

final class StationTests: XCTestCase {
    
    func test_distance_returns_non_zero_value() throws {
        let source = Station(
            id: 80416,
            name: "Kraków Główny",
            location: .init(latitude: 50.068509, longitude: 19.947983),
            hits: 4629,
            city: "Kraków",
            region: "małopolskie",
            country: "Polska"
        )
        let destination = Station(
            id: 30601,
            name: "Poznań Główny",
            location: .init(latitude: 52.41778197, longitude: 16.97139025),
            hits: 4210,
            city: "Poznań",
            region: "wielkopolskie",
            country: "Polska"
        )
        
        let result = source.distance(to: destination)
        
        XCTAssertEqual(result.value, 333878.30, accuracy: 0.01)
    }
    
    func test_distance_when_source_and_target_are_in_the_same_place_returns_zero() throws {
        let station = Station(
            id: 30601,
            name: "Poznań Główny",
            location: .init(latitude: 52.41778197, longitude: 16.97139025),
            hits: 4210,
            city: "Poznań",
            region: "wielkopolskie",
            country: "Polska"
        )
        
        let result = station.distance(to: station)
        
        XCTAssertTrue(result.value.isZero)
    }
}
