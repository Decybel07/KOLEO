//
//  StationKeyword.swift
//  KOLEO
//
//  Created by Adrian Bobrowski on 28/10/2023.
//

import Foundation

struct StationKeyword: Identifiable {
    
    var id: Int
    var keyword: String
    var stationId: Int
    
    init(id: Int, keyword: String, stationId: Int) {
        self.id = id
        self.keyword = Self.folding(text: keyword)
        self.stationId = stationId
    }
}

// MARK: - Equatable
extension StationKeyword: Equatable {
    
    static func == (lhs: StationKeyword, rhs: StationKeyword) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Utils
extension StationKeyword {
    
    /// Convert a string with case and diacritic insensitive character folding options applied.
    fileprivate static func folding(text: String) -> String {
        text
            .folding(options: [.caseInsensitive, .diacriticInsensitive], locale: nil)
            .replacing("ł", with: "l")
    }
    
    /// Returns a Boolean value indicating whether the keyword contains the given string.
    func contains(text: String) -> Bool {
        self.keyword.localizedStandardContains(Self.folding(text: text))
    }
}

extension Sequence where Self.Element == StationKeyword {
    
    /// Returns an array containing, in order, the elements of the sequence that contains the given filter.
    /// - Returns: An array of the elements  that accept the given filter.
    func filter(_ text: String) -> [Element] {
        let text = Element.folding(text: text)
    
        return self.filter {
            $0.keyword.localizedStandardContains(text)
        }
    }
}
