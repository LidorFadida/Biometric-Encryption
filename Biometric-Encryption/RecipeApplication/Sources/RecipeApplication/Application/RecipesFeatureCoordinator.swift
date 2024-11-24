//
//  RecipesFeatureCoordinator.swift
//  RecipeApplication
//
//  Created by Lidor Fadida on 24/11/2024. 22/11/2024.
//

import LocalAuthentication
import Common
import Recipes
import Combine
import UIKit
import SwiftUI

public class RecipesFeatureCoordinator: RecipesCoordinatorProtocol {
    private var storeBag = Set<AnyCancellable>()
    public weak var navigationController: UINavigationController?
    
    public let biometricService: RecipeBiometricService
    public let apiService: any RecipesFetcherProtocol
    public let cryptoHelper: RecipeCryptoHelper
    private var service: String {
        let keychainService = "Y29tLmJpb21ldHJpYy5SZWNpcGVBcHBsaWNhdGlvbg=="
        return keychainService.decodeBase64URL ?? "com.default.keyService"
    }
    
    public init(
        navigationController: UINavigationController?,
        biometricService: RecipeBiometricService,
        apiService: any RecipesFetcherProtocol,
        cryptoHelper: RecipeCryptoHelper
    ) {
        self.navigationController = navigationController
        self.biometricService = biometricService
        self.apiService = apiService
        self.cryptoHelper = cryptoHelper
        
        observeApplicationTermination()
    }
    
    private func observeApplicationTermination() {
        NotificationCenter.default
            .publisher(for: UIApplication.willTerminateNotification)
            .sink { [weak self] _ in
                guard let self else { return }
                try? self.biometricService.deleteKeyFromKeychain(service: self.service, account: nil)
            }
            .store(in: &storeBag)
    }
    
    public func start() async {
        let viewModel = await RecipesListViewModel(client: apiService) { [weak self] recipe in
            guard let self else { assertionFailure(); return }
            await self.recipeTapped(recipe: recipe)
        } fetchingRecipesFailed: { [weak self] error in
            self?.presentSimplePopup(message: error.localizedDescription)
        }
        let rootView = await RecipesListView(viewModel: viewModel)
            .navigationTitle("Recipes")
            .colorScheme(.light)
        let rootViewController = await UIHostingController(rootView: rootView)
        await navigationController?.setViewControllers([rootViewController], animated: false)
    }
    
    @MainActor
    private func recipeTapped(recipe: RecipesListProperties.Recipe) async {
        guard let navigationController else { assertionFailure(); return }
        do {
            let account = recipe.identifier
            let key = try await biometricService.getEncryptionKey(service: service, account: account)
            let targetRecipe = try EncryptableRecipeEntity(recipe: recipe)
            
            let biometricRepository = try EncryptedEntityProvider<EncryptableRecipeEntity, DecryptableRecipeEntity>(
                key: key,
                target: targetRecipe,
                cryptoHelper: cryptoHelper
            )
            
            let viewModel = RecipeDetailsViewModel(biometricRepository: biometricRepository) { [weak self] error in
                self?.presentSimplePopup(message: error.localizedDescription) {
                    self?.navigationController?.popViewController(animated: true)
                }
            }
            let rootView = RecipeDetailsView(viewModel: viewModel)
                .navigationTitle(recipe.name)
            let viewController = LFHostingController(shouldShowNavigationBar: true, rootView: rootView) { [weak self] in
                guard let self else { return }
                try? self.biometricService.deleteKeyFromKeychain(service: self.service, account: account)
            }
            navigationController.pushViewController(viewController, animated: true)
        } catch let localAuthenticationError as LAError {
            handle(localAuthentication: localAuthenticationError)
        } catch {
            presentSimplePopup(message: error.localizedDescription)
        }
    }
    
    private func handle(localAuthentication: LAError) {
        let message = switch localAuthentication.code {
        case .userCancel:
            "User canceled local authentication"
        case .biometryNotAvailable:
            "User decline the usage of local authentication"
        case .biometryNotEnrolled:
            "User should enroll the local authentication"
        case .biometryLockout:
            "User should unlock the local authentication using passcode"
        default:
            "General Error"
        }
        presentSimplePopup(message: message)
    }
    
    private func presentSimplePopup(message: String, completion: (() -> Void)? = nil) {
        let simplePopup = SimplePopup(message: message)
        let popupViewController = LFHostingController(shouldShowNavigationBar: false, rootView: simplePopup)
        popupViewController.modalTransitionStyle = .crossDissolve
        popupViewController.modalPresentationStyle = .overFullScreen
        navigationController?.present(popupViewController, animated: true, completion: completion)
    }
}


fileprivate extension EncryptableRecipeEntity {
    init(recipe: RecipesListProperties.Recipe) throws {
        let error = NSError(domain: "\(#function)", code: -1_000_000)
        guard let name = recipe.name.data(using: .utf8) else { throw error }
        guard let fats = recipe.fats.data(using: .utf8) else { throw error }
        guard let calories = recipe.calories.data(using: .utf8) else { throw error }
        guard let carbos = recipe.carbos.data(using: .utf8) else { throw error }
        guard let description = recipe.description.data(using: .utf8) else { throw error }
        guard let image = recipe.image.data(using: .utf8) else { throw error }
        
        self.init(
            name: name,
            fats: fats,
            calories: calories,
            carbos: carbos,
            description: description,
            image: image
        )
    }
}
