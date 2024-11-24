//
//  RecipesListViewModelProtocol.swift
//  Recipes
//
//  Created by Lidor Fadida on 24/11/2024.
//

import Combine

public protocol RecipesListViewModelProtocol {
    var state: RecipesListProperties.State { get }
    var client: any RecipesFetcherProtocol { get }
    var onRecipeTapped: ((RecipesListProperties.Recipe) async -> Void)? { get }
    var fetchingRecipesFailed: ((any Error) async -> Void)? { get }
    
    @MainActor init(
        state: RecipesListProperties.State,
        client: any RecipesFetcherProtocol,
        onRecipeTapped: ((RecipesListProperties.Recipe) async -> Void)?,
        fetchingRecipesFailed: ((any Error) async -> Void)?
    )
    
    func start()
    func didTap(recipe: RecipesListProperties.Recipe) async
}
