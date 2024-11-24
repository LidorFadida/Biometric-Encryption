//
//  CryptoHelperProtocol.swift
//  Biometric
//
//  Created by Lidor Fadida on 24/11/2024.
//

import Foundation

public protocol CryptoHelperProtocol where Key: ContiguousBytes {
    associatedtype Key
    func encrypt(_ value: Data, withKey key: Key) throws -> Data
    func decrypt(_ encryptedData: Data, withKey key: Key) throws -> Data
}
