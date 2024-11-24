//
//  DecryptableEntityProtocol.swift
//  Biometric
//
//  Created by Lidor Fadida on 24/11/2024.
//

import Foundation

public protocol DecryptableEntityProtocol: Codable {
    var name: String { get }
    var fats: String { get }
    var calories: String { get }
    var carbos: String { get }
    var description: String { get }
    var image: String { get }
    
    init(name: String, fats: String, calories: String, carbos: String, description: String, image: String)
}
