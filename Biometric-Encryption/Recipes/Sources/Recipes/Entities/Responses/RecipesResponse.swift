//
//  RecipesResponse.swift
//  Recipes
//
//  Created by Lidor Fadida on 24/11/2024.
//

import Foundation

public struct RecipesResponse: Decodable {
    public let id: String
    public let name: String
    public let thumb: String
    public let fats: String
    public let calories: String
    public let carbos: String
    public let description: String
    public let image: String
}
