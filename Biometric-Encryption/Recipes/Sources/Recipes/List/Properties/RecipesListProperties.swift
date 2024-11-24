//
//  RecipesListProperties.swift
//  Recipes
//
//  Created by Lidor Fadida on 24/11/2024.
//

import Foundation

public struct RecipesListProperties {
    public enum State {
        case loading
        case fetched([Recipe])
        case fetchFailed
    }
    
    public struct Recipe: Identifiable {
        public let id: UUID
        public let identifier: String
        public let name: String
        public let thumb: String
        public let fats: String
        public let calories: String
        public let carbos: String
        public let description: String
        public let image: String
        
        public init(id: UUID = UUID(), identifier: String, name: String, thumb: String, fats: String, calories: String, carbos: String, description: String, image: String) {
            self.id = id
            self.identifier = identifier
            self.name = name
            self.thumb = thumb
            self.fats = fats
            self.calories = calories
            self.carbos = carbos
            self.description = description
            self.image = image
        }
        
        public init(response: RecipesResponse, id: UUID = UUID()) {
            self.calories = response.calories
            self.carbos = response.carbos
            self.description = response.description
            self.fats = response.fats
            
            self.identifier = response.id
            self.image = response.image
            self.name = response.name
            self.thumb = response.thumb
            self.id = id
        }
    }

}

