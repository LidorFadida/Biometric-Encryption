//
//  EncryptableRecipe.swift
//  Recipes
//
//  Created by Lidor Fadida on 24/11/2024.
//

import Biometric
import Foundation

public struct EncryptableRecipeEntity: EncryptableEntityProtocol {
    public let name: Data
    public let fats: Data
    public let calories: Data
    public let carbos: Data
    public let description: Data
    public let image: Data
    
    public init(name: Data, fats: Data, calories: Data, carbos: Data, description: Data, image: Data) {
        self.name = name
        self.fats = fats
        self.calories = calories
        self.carbos = carbos
        self.description = description
        self.image = image
    }
}
