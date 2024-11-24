//
//  RecipesFetcherProtocol.swift
//  Recipes
//
//  Created by Lidor Fadida on 24/11/2024.
//

import Foundation

public protocol RecipesFetcherProtocol {
    func fetchRecipes() async throws -> [RecipesResponse]
}
