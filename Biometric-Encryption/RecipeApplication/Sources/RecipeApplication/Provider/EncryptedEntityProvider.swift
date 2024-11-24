//
//  EncryptedEntityProvider.swift
//  RecipeApplication
//
//  Created by Lidor Fadida on 24/11/2024. 22/11/2024.
//

import Recipes
import Biometric
import Foundation

public struct EncryptedEntityProvider<Encrypted: EncryptableEntityProtocol, Decrypted: DecryptableEntityProtocol> {
    private let key: RecipeBiometricService.Key
    private let data: Data
    private let cryptoHelper: RecipeCryptoHelper
    
    public init(key: RecipeBiometricService.Key, target: Encrypted, cryptoHelper: RecipeCryptoHelper) throws {
        self.key = key
        
        let name = try cryptoHelper.encrypt(target.name, withKey: key)
        let imageData =  try cryptoHelper.encrypt(target.image, withKey: key)
        let fats = try cryptoHelper.encrypt(target.fats, withKey: key)
        let calories = try cryptoHelper.encrypt(target.calories, withKey: key)
        let carbos = try cryptoHelper.encrypt(target.carbos, withKey: key)
        let description = try cryptoHelper.encrypt(target.description, withKey: key)
        
        let encrypted = Encrypted(
            name: name,
            fats: fats,
            calories: calories,
            carbos: carbos,
            description: description,
            image: imageData
        )
        let data = try JSONEncoder().encode(encrypted)
        let encryptedData = try cryptoHelper.encrypt(data, withKey: key)
        
        self.data = encryptedData
        self.cryptoHelper = cryptoHelper
    }

    private func decrypt(encryptedItem: Data) throws -> String {
        let decryptedData = try cryptoHelper.decrypt(encryptedItem, withKey: key)
        guard let decryptedString = String(data: decryptedData, encoding: .utf8) else {
            throw NSError(domain: #function, code: -2_000)
        }
        return decryptedString
    }
    
    public func decryptedData() async throws -> Decrypted {
        let data: Data = try cryptoHelper.decrypt(data, withKey: key)
        let encrypted = try JSONDecoder().decode(Encrypted.self, from: data)
        
        let name = try decrypt(encryptedItem: encrypted.name)
        let fats = try decrypt(encryptedItem: encrypted.fats)
        let calories = try decrypt(encryptedItem: encrypted.calories)
        let carbos = try decrypt(encryptedItem: encrypted.carbos)
        let description = try decrypt(encryptedItem: encrypted.description)
        let image = try decrypt(encryptedItem: encrypted.image)
        
        return Decrypted(
            name: name,
            fats: fats,
            calories: calories,
            carbos: carbos,
            description: description,
            image: image
        )
    }
}
