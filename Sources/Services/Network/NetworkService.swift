//
//  NetworkService.swift
//  KOLEO
//
//  Created by Adrian Bobrowski on 27/10/2023.
//

import Foundation

protocol NetworkService {
    
    /// Downloads the contents based on the specified URL and delivers the data asynchronously.
    /// - Parameters:
    ///   - url: The URL for the request.
    ///   - headers: A dictionary containing all of the HTTP header fields for a request.
    /// - Returns: An asynchronously-delivered URL contents as a Data instance.
    func data(url: String, headers: [String: String]?) async throws -> Data
}
