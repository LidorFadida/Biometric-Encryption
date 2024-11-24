//
//  RecipesListViewModel.swift
//  RecipeApplication
//
//  Created by Lidor Fadida on 24/11/2024. 22/11/2024.
//

import Recipes

import Foundation
import Combine

public protocol ObservableRecipesListViewModelProtocol: RecipesListViewModelProtocol & ObservableObject {
    
}

public class RecipesListViewModel: ObservableRecipesListViewModelProtocol {
    @Published @MainActor private(set) public var state: RecipesListProperties.State
    public let client: any RecipesFetcherProtocol
    public let onRecipeTapped: ((RecipesListProperties.Recipe) async -> Void)?
    public let fetchingRecipesFailed: ((any Error) async -> Void)?
    
    @MainActor
    public required init(
        state: RecipesListProperties.State = .loading,
        client: any RecipesFetcherProtocol,
        onRecipeTapped: ((RecipesListProperties.Recipe) async -> Void)? = nil,
        fetchingRecipesFailed: ((any Error) async -> Void)? = nil
    ) {
        self.state = state
        self.client = client
        self.onRecipeTapped = onRecipeTapped
        self.fetchingRecipesFailed = fetchingRecipesFailed
    }
    
    private lazy var _start: Void = {
        Task { [weak self] in
            guard let self else { return }
            guard case .loading = state else { return }
            await self.fetchRecipes()
        }
    }()
    
    @MainActor
    private func fetchRecipes() async {
        do {
            let responses: [RecipesResponse] = try await client.fetchRecipes()
            let recipes = responses.compactMap { RecipesListProperties.Recipe(response: $0) }
            self.state = .fetched(recipes)
        } catch {
            await fetchingRecipesFailed?(error)
            self.state = .fetchFailed
        }
        
    }
    
    public func start() {
        let _ = _start
    }
    
    public func didTap(recipe: RecipesListProperties.Recipe) async {
        await onRecipeTapped?(recipe)
    }
}
