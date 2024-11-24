//
//  RecipeCoordinatorProtocol.swift
//  Recipes
//
//  Created by Lidor Fadida on 24/11/2024.
//

import Common
import Network
import Biometric

protocol RecipeCoordinatorProtocol: CoordinatorProtocol {
    var biometricService: RecipeBiometricService { get }
    var apiService: any NetworkFetcher { get }
    var cryptoHelper: RecipeCryptoHelper { get }
}
