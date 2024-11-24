//
//  RecipesFetcher.swift
//  Recipes
//
//  Created by Lidor Fadida on 24/11/2024.
//

import Network
import Foundation

public struct RecipesFetcher: RecipesFetcherProtocol {
    private let recipesURL: URL
    private let client: any NetworkFetcher
    
    private init(recipesURL: URL, client: any NetworkFetcher) {
        self.recipesURL = recipesURL
        self.client = client
    }
    
    public func fetchRecipes() async throws -> [RecipesResponse] {
        return try await client.fetch(from: recipesURL)
    }
    
    public static func make(environment: Environment) throws -> Self {
        switch environment {
        case .mock:
            guard let url = environment.endPoint else {
                throw NSError(domain: "\(#function)", code: -4_000)
            }
            return Self(recipesURL: url, client: NetworkServiceMocker())
        case .restAPI:
            guard let url = environment.endPoint else {
                throw NSError(domain: "\(#function)", code: -4_000)
            }
            return Self(recipesURL: url, client: NetworkServiceAPI())
        }
    }
}
