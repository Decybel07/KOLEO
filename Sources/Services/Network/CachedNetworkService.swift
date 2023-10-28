//
//  CachedNetworkService.swift
//  KOLEO
//
//  Created by Adrian Bobrowski on 27/10/2023.
//

import Foundation

struct CachedNetworkService: NetworkService {
    
    private let cache: URLCache
    private let lifespan: TimeInterval?
    private let session: URLSession
    
    /// An object that coordinates a group of related, network data transfer tasks.
    /// Use the caching logic defined in the protocol implementation, if any, for a particular URL load request.
    /// - Parameter lifespan: Maximum life span (in seconds) of the cache for a specific URL request
    init(lifespan: TimeInterval? = nil) {
        let cache = URLCache.shared
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .useProtocolCachePolicy
        configuration.urlCache = cache
        
        self.cache = cache
        self.lifespan = lifespan
        self.session = URLSession(configuration: configuration)
    }
    
    func data(url: String, headers: [String: String]?) async throws -> Data {
        guard var request = URL(string: url).map({ URLRequest(url: $0) }) else {
            throw URLError(.badURL)
        }
        headers?.forEach {
            request.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        do {
            let (data, response) = try await self.session.data(for: request)
            
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200..<300:
                    break
                default:
                    throw URLError(.unknown)
                }
            } 
            
            self.cache.storeCachedResponse(.init(
                response: response,
                data: data, userInfo: ["date": Date.now],
                storagePolicy: .allowed
            ), for: request)
            
            return data
        } catch {
            guard let cache = self.session.configuration.urlCache?.cachedResponse(for: request) else {
                throw error
            }
            if let lifespan = self.lifespan,
                let date = cache.userInfo?["date"] as? Date,
                lifespan + date.timeIntervalSinceNow < 0
            {
                self.cache.removeCachedResponse(for: request)
                throw error
            }
            
            return cache.data
        }
    }
}
