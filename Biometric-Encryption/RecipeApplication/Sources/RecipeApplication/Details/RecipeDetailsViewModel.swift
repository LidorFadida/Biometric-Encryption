//
//  RecipeDetailsViewModel.swift
//  RecipeApplication
//
//  Created by Lidor Fadida on 24/11/2024. 22/11/2024.
//

import Recipes
import Common
import Biometric
import Combine
import UIKit

protocol ObservableRecipeDetailsViewModelProtocol: RecipeDetailsViewModelProtocol & ObservableObject {
    var biometricRepository: EncryptedEntityProvider<EncryptableRecipeEntity, DecryptableRecipeEntity> { get }
    var decryptionFailed: ((any Error) async -> Void)? { get }
    
    init(biometricRepository: EncryptedEntityProvider<EncryptableRecipeEntity, DecryptableRecipeEntity>, decryptionFailed: ((any Error) async -> Void)?)
}

public class RecipeDetailsViewModel: ObservableRecipeDetailsViewModelProtocol {
    public let biometricRepository: EncryptedEntityProvider<EncryptableRecipeEntity, DecryptableRecipeEntity>
    
    public let decryptionFailed: ((any Error) async -> Void)?
    
    @Published @MainActor public private(set) var state: RecipeDetailsProperties.State = .loading

    public required init(biometricRepository: EncryptedEntityProvider<EncryptableRecipeEntity, DecryptableRecipeEntity>, decryptionFailed: ((any Error) async -> Void)? = nil) {
        self.biometricRepository = biometricRepository
        self.decryptionFailed = decryptionFailed
    }
    
    private lazy var _start: Void = {
        Task { @MainActor [weak self] in
            guard let self else { return }
            do {
                let decrypted = try await biometricRepository.decryptedData()
                let recipeConfiguration = RecipeItemViewConfiguration(
                    name: decrypted.name,
                    fats: decrypted.fats,
                    calories: decrypted.calories,
                    carbos: decrypted.carbos,
                    image: decrypted.image
                )
                self.state = .decrypted(recipeConfiguration, decrypted.description)
            } catch {
                await self.decryptionFailed?(error)
                assertionFailure()
            }
        }
    }()
    
    public func start() {
       let _ = _start
    }
}
