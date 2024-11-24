//
//  RecipeDetailsViewModelProtocol.swift
//  Recipes
//
//  Created by Lidor Fadida on 24/11/2024.
//

import Common

public protocol RecipeDetailsViewModelProtocol {
    var state: RecipeDetailsProperties.State { get }
    
    func start()
}
