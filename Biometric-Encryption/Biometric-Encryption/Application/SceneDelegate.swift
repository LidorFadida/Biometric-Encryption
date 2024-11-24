//
//  SceneDelegate.swift
//  Recipes
//
//  Created by Lidor Fadida on 24/11/2024.
//

import UIKit
import Recipes
import RecipeApplication
import Biometric
import Network

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private var recipesFeatureCoordinator: (any RecipesCoordinatorProtocol)?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        let navigationController = UINavigationController()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
        
        Task { @MainActor [weak self] in
            await self?.initializeFeatureCoordinator(navigationController: navigationController)
        }
    }
    
    @MainActor
    private func initializeFeatureCoordinator(navigationController: UINavigationController) async {
        let biometricService = RecipeBiometricService()
        guard let recipesFetcher = try? RecipesFetcher.make(environment: .restAPI) else { assertionFailure(); return }
        let cryptoHelper = RecipeCryptoHelper()
        let feature = RecipesFeatureCoordinator(
            navigationController: navigationController,
            biometricService: biometricService,
            apiService: recipesFetcher,
            cryptoHelper: cryptoHelper
        )
        await feature.start()
        self.recipesFeatureCoordinator = feature
    }
}
