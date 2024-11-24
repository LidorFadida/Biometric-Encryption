//
//  NetworkServiceAPI.swift
//  Recipes
//
//  Created by Lidor Fadida on 24/11/2024.
//
import UIKit

public struct NetworkServiceAPI: NetworkFetcher {
    
    public init() {}
    
    public func fetch<T: Decodable>(from url: URL) async throws -> T {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}
