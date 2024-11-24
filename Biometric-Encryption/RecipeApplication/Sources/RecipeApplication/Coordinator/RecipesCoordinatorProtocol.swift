//
//  RecipesCoordinatorProtocol.swift
//  RecipeApplication
//
//  Created by Lidor Fadida on 24/11/2024. 23/11/2024.
//

import Common
import Recipes

public protocol RecipesCoordinatorProtocol: CoordinatorProtocol {
    var biometricService: RecipeBiometricService { get }
    var apiService: any RecipesFetcherProtocol { get }
    var cryptoHelper: RecipeCryptoHelper { get }
}
