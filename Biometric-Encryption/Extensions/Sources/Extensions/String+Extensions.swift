//
//  String+Extensions.swift
//  Extensions
//
//  Created by Lidor Fadida on 24/11/2024.
//

import Foundation

public extension String {
    var decodeBase64URL: String? {
        guard let decodedData = Data(base64Encoded: self) else { return nil }
        guard let decodedString = String(data: decodedData, encoding: .utf8) else { return nil }
        return decodedString
    }
}
