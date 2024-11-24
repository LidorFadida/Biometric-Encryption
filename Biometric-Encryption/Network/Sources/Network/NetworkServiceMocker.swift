//
//  NetworkServiceMocker.swift
//  Recipes
//
//  Created by Lidor Fadida on 24/11/2024.
//

import UIKit

public struct NetworkServiceMocker: NetworkFetcher {
    
    public func fetch<T: Decodable>(from url: URL) async throws -> T {
        return try Bundle.main.loadAndDecodeJSON(from: url)
    }

    public init() {}
}

/// Private Bundle extension utility to load JSON from a URL.
private extension Bundle {
    
    func loadAndDecodeJSON<T: Decodable>(from fileURL: URL) throws -> T {
        let decodingError = NSError(domain: "\(#function)", code: 5_000)
        let fileData = try Data(contentsOf: fileURL)
        
        guard let json = try JSONSerialization.jsonObject(with: fileData, options: []) as? [String: String] else { throw decodingError }
        guard let base64String = json["base"] else { throw decodingError }
        guard let decodedData = Data(base64Encoded: base64String) else { throw decodingError }
        
        let recipes = try JSONDecoder().decode(T.self, from: decodedData)
        return recipes
    }
}
