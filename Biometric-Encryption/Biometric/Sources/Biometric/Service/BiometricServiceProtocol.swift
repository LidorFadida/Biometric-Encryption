//
//  BiometricServiceProtocol.swift
//  Biometric
//
//  Created by Lidor Fadida on 24/11/2024.
//

import Foundation

public protocol BiometricServiceProtocol where Key: ContiguousBytes {
    associatedtype Key
    func getEncryptionKey(service: String, account: String) async throws -> Key
    func saveKeyToKeychain(key: Key, service: String, account: String) throws
    func loadKeyFromKeychain(service: String, account: String) throws -> Key
    @discardableResult func deleteKeyFromKeychain(service: String, account: String?) throws -> Bool
}
