//
//  EncryptableEntityProtocol.swift
//  Biometric
//
//  Created by Lidor Fadida on 24/11/2024.
//

import Foundation

public protocol EncryptableEntityProtocol: Codable {
    var name: Data { get }
    var fats: Data { get }
    var calories: Data { get }
    var carbos: Data { get }
    var description: Data { get }
    var image: Data { get }
    
    init(name: Data, fats: Data, calories: Data, carbos: Data, description: Data, image: Data)
}
