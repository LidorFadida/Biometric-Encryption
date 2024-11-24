//
//  RecipeDetailsProperties.swift
//  Recipes
//
//  Created by Lidor Fadida on 24/11/2024.
//

import Common
import Foundation

public struct RecipeDetailsProperties {
    public enum State {
        case loading
        case decrypted(RecipeItemViewConfiguration, String)
    }
}
