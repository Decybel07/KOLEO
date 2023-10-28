//
//  App.swift
//  KOLEO
//
//  Created by Adrian Bobrowski on 27/10/2023.
//

import SwiftUI

@main
struct App: SwiftUI.App {
    
    var body: some Scene {
        lazy var networkService: NetworkService = CachedNetworkService(lifespan: 86400)
        lazy var stationRepositoryService: StationRepositoryService = ApiStationRepositoryService(networkService: networkService)
        
        return WindowGroup {
            MainView()
                .environmentObject(MainViewModel(stationRepositoryService: stationRepositoryService))
        }
    }
}
