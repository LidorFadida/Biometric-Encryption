//
//  DecryptedRecipeEntity.swift
//  Recipes
//
//  Created by Lidor Fadida on 24/11/2024.
//

import Biometric
import Foundation

public struct DecryptableRecipeEntity: DecryptableEntityProtocol {
    public let name: String
    public let fats: String
    public let calories: String
    public let carbos: String
    public let description: String
    public let image: String
    
    public init(name: String, fats: String, calories: String, carbos: String, description: String, image: String) {
        self.name = name
        self.fats = fats
        self.calories = calories
        self.carbos = carbos
        self.description = description
        self.image = image
    }
}
