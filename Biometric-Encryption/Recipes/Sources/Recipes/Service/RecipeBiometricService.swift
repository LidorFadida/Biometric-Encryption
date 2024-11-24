//
//  RecipeBiometricService.swift
//  Recipes
//
//  Created by Lidor Fadida on 24/11/2024.
//

import Biometric
import Foundation
import LocalAuthentication
import CryptoKit

public struct RecipeBiometricService: BiometricServiceProtocol {
    public typealias Key = SymmetricKey
    
    public init() {}
    
    public func getEncryptionKey(service: String, account: String) async throws -> Key {
        /// Checks if the key already exists in the Keychain
        if let existingKey = try? loadKeyFromKeychain(service: service, account: account) {
            return existingKey
        }
        let context = LAContext()
        let policyEvaluation = try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Authenticate to create encryption key")
        guard policyEvaluation else { throw NSError(domain: "\(#function)", code: -1_00, userInfo: nil) }
        let newKey = SymmetricKey(size: .bits256)
        try self.saveKeyToKeychain(key: newKey, service: service, account: account)
        return newKey
    }

    public func saveKeyToKeychain(key: SymmetricKey, service: String, account: String) throws {
        let keyData = key.withUnsafeBytes { Data(Array($0)) }

        guard let accessControl = SecAccessControlCreateWithFlags(
            nil,
            kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
            [.userPresence],
            nil
        ) else {
            throw NSError(domain: "\(#function)", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create SecAccessControl"])
        }
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: keyData,
            kSecAttrAccessControl as String: accessControl
        ]

        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else { throw NSError(domain: NSOSStatusErrorDomain, code: Int(status), userInfo: nil) }
    }

    public func loadKeyFromKeychain(service: String, account: String) throws -> SymmetricKey {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true
        ]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess else { throw NSError(domain: NSOSStatusErrorDomain, code: Int(status), userInfo: nil) }
        guard let keyData = item as? Data else { throw NSError(domain: "\(#function)", code: -2, userInfo: nil) }
        return SymmetricKey(data: keyData)
    }
    
    ///If account is nil, all the service keys are deleted.
    @discardableResult public func deleteKeyFromKeychain(service: String, account: String?) throws -> Bool {
        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
        ]

        if let account { query[kSecAttrAccount as String] =  account }
 
        let status = SecItemDelete(query as CFDictionary)

        switch status {
        case errSecSuccess:
            return true
        case errSecItemNotFound:
            return false
        default:
            throw NSError(domain: "\(#function)", code: 10_000, userInfo: [ NSLocalizedDescriptionKey: "Failed to delete key: \(status)."])
        }
    }
}


