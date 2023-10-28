//
//  MainViewModel.swift
//  KOLEO
//
//  Created by Adrian Bobrowski on 27/10/2023.
//

import Combine
import Foundation
import CoreLocation

class MainViewModel: ObservableObject {
    
    @Published private(set) var stations: [Station] = []
    @Published private(set) var keywords: [StationKeyword] = []
    @Published private(set) var processingCount: Int = 0
    @Published private(set) var distance: Measurement<UnitLength>?
    @Published private(set) var error: Error?
    
    @Published var source: Station?
    @Published var destination: Station?
    
    private let stationRepositoryService: StationRepositoryService
    private let fetchDataSubject = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(stationRepositoryService: StationRepositoryService) {
        self.stationRepositoryService = stationRepositoryService
        self.binding()
    }
    
    func refresh() {
        self.error = nil
        self.fetchDataSubject.send(())
    }
}

// MARK: - Binding
private extension MainViewModel {
    
    func binding() {
        self.bindFetchingData()
    }
    
    func bindFetchingData() {
        self.fetchDataSubject
            .prepend(())
            .map { [unowned self] in self.fetchStations() }
            .switchToLatest()
            .map { $0.sorted(by: >) }
            .assign(to: &self.$stations)
        
        self.fetchDataSubject
            .prepend(())
            .map { [unowned self] in self.fetchKeywords() }
            .switchToLatest()
            .assign(to: &self.$keywords)
    }
    
    func bindDistance() {
        Publishers.CombineLatest(self.$source, self.$destination)
            .map { source, destination in
                guard let source, let destination else {
                    return nil
                }
                return source.distance(to: destination)
            }
            .assign(to: &self.$distance)
    }
}

// MARK: - Requests
private extension MainViewModel {
    
    func fetchStations() -> AnyPublisher<[Station], Never> {
        self.fetch(operation: self.stationRepositoryService.allStations, default: [])
    }
    
    func fetchKeywords() -> AnyPublisher<[StationKeyword], Never> {
        self.fetch(operation: self.stationRepositoryService.allKeywords, default: [])
    }
    
    private func fetch<Output>(operation: @escaping () async throws -> Output, default: Output) -> AnyPublisher<Output, Never> {
        Future<Output, Error>{ promise in
            Task {
                do {
                    let output = try await operation()
                    promise(.success(output))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .catch { [unowned self] error -> Just<Output> in
            self.error = error
            return Just(`default`)
        }
        .handleEvents(
            receiveSubscription: { [weak self] _ in
                self?.processingCount += 1
            },
            receiveCompletion: { [weak self] _ in
                self?.processingCount -= 1
            },
            receiveCancel: { [weak self] in
                self?.processingCount -= 1
            }
        )
        .eraseToAnyPublisher()
    }
}
