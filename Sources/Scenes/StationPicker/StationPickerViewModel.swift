//
//  StationPickerViewModel.swift
//  KOLEO
//
//  Created by Adrian Bobrowski on 27/10/2023.
//

import Combine
import Foundation

class StationPickerViewModel: ObservableObject {
    
    @Published private(set) var searchResults: [Station] = []
    @Published var filter: String = ""
    
    private let stations: [Int: Station]
    private let keywords: [StationKeyword]
    
    private var cancellables = Set<AnyCancellable>()
    
    init(stations: [Station], keywords: [StationKeyword]) {
        self.keywords = keywords
        self.stations = stations.reduce(into: [:]) { $0[$1.id] = $1 }
        self.searchResults = stations
        
        self.binding()
    }
}

// MARK: - Binding
private extension StationPickerViewModel {
    
    func binding() {
        self.bindFilter()
    }
    
    func bindFilter() {
        self.$filter
            .dropFirst()
            .debounce(for: 0.25, scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.global(qos: .userInteractive))
            .map { [unowned self] filter in
                if filter.isEmpty {
                    return Array(self.stations.values)
                }
                
                return Set(self.keywords.filter(filter).map { $0.stationId })
                    .compactMap { self.stations[$0] }
            }
            .map { $0.sorted(by: >) }
            .receive(on: DispatchQueue.main)
            .assign(to: &self.$searchResults)
    }
}
