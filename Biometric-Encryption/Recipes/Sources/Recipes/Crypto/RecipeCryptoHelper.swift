//
//  RecipeCryptoHelper.swift
//  Recipes
//
//  Created by Lidor Fadida on 24/11/2024.
//

import Biometric
import CryptoKit
import Foundation

public struct RecipeCryptoHelper: CryptoHelperProtocol {
    public typealias Key = SymmetricKey
    
    public init() {}

    public func encrypt(_ value: Data, withKey key: SymmetricKey) throws -> Data {
        let sealedBox = try AES.GCM.seal(value, using: key)
        guard let encryptedData = sealedBox.combined else {
            throw NSError(domain: "Encryption", code: -1_000, userInfo: [NSLocalizedDescriptionKey: "Failed to Encrypt data"])
        }
        return encryptedData
    }

    public func decrypt(_ encryptedData: Data, withKey key: SymmetricKey) throws -> Data {
        let sealedBox = try AES.GCM.SealedBox(combined: encryptedData)
        return try AES.GCM.open(sealedBox, using: key)
    }
}
