//
//  Environment.swift
//  Recipes
//
//  Created by Lidor Fadida on 24/11/2024.
//

import Foundation

public enum Environment {
    case mock
    case restAPI
    
    var endPoint: URL? {
        return switch self {
        case .mock:
            Bundle.module.url(forResource: "mock", withExtension: "json")
        case .restAPI:
            decodedRest
        }
    }
    
    private var decodedRest: URL? {
        let encoded = "aHR0cHM6Ly9oZi1hbmRyb2lkLWFwcC5zMy1ldS13ZXN0LTEuYW1hem9uYXdzLmNvbS9hbmRyb2lkLXRlc3QvcmVjaXBlcy5qc29u"
        guard let decoded = encoded.decodeBase64URL else { return nil }
        return URL(string: decoded)
    }
}
