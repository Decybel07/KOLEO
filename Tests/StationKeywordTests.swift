//
//  StationKeywordTests.swift
//  KOLEOTests
//
//  Created by Adrian Bobrowski on 28/10/2023.
//

import XCTest
@testable import KOLEO

final class StationKeywordTests: XCTestCase {

    func test_init_when_folding_is_required() throws {
        let keyword = "Poznań Główny"
        
        let result = StationKeyword(id: 1, keyword: keyword, stationId: 2)
        
        XCTAssertEqual(result.id, 1)
        XCTAssertEqual(result.stationId, 2)
        XCTAssertEqual(result.keyword, "poznan glowny")
        XCTAssertNotEqual(result.keyword, keyword)
    }
    
    func test_contains_when_keyword_contains_text_returns_contains() throws {
        let keyword = StationKeyword(id: 0, keyword: "Poznań Główny", stationId: 0)
        
        let result = keyword.contains(text: "łow")
        
        XCTAssertTrue(result)
    }
    
    func test_contains_when_keyword_dont_contains_text_returns_not_contains() throws {
        let keyword = StationKeyword(id: 0, keyword: "Poznań Główny", stationId: 0)
        
        let result = keyword.contains(text: "abc")
        
        XCTAssertFalse(result)
    }
    
    func test_filter_when_all_keywords_contains_text_returns_source_array() throws {
        let keywords = [
            StationKeyword(id: 0, keyword: "Poznań Główny", stationId: 0),
            StationKeyword(id: 1, keyword: "Poznań Wschód", stationId: 1),
        ]
        
        let result = keywords.filter("Poznań")
        
        XCTAssertEqual(result, keywords)
    }
    
    func test_filter_when_some_keywords_contains_text_returns_filtered_array() throws {
        let keywords = [
            StationKeyword(id: 0, keyword: "Poznań Główny", stationId: 0),
            StationKeyword(id: 1, keyword: "Poznań Wschód", stationId: 1),
        ]
        
        let result = keywords.filter("Wschód")
        
        XCTAssertEqual(result, [StationKeyword(id: 1, keyword: "Poznań Wschód", stationId: 1)])
    }
    
    func test_filter_when_text_isEmpty_returns_empty_array() throws {
        let keywords = [
            StationKeyword(id: 0, keyword: "Poznań Główny", stationId: 0),
            StationKeyword(id: 1, keyword: "Poznań Wschód", stationId: 1),
        ]
        
        let result = keywords.filter("")
        
        XCTAssertTrue(result.isEmpty)
    }
    
    func test_filter_when_keywords_dont_contains_text_returns_empty_array() throws {
        let keywords = [
            StationKeyword(id: 0, keyword: "Poznań Główny", stationId: 0),
            StationKeyword(id: 1, keyword: "Poznań Wschód", stationId: 1),
        ]
        
        let result = keywords.filter("Kraków")
        
        XCTAssertTrue(result.isEmpty)
    }
}
