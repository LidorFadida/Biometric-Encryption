//
//  CapsuleGridItem 2.swift
//  Common
//
//  Created by Lidor Fadida on 24/11/2024. 22/11/2024.
//

import SwiftUI

public struct TextCapsuleGridItemConfiguration: Identifiable {
    public let text: String
    public let id: UUID
    
    public init(text: String, id: UUID = UUID()) {
        self.text = text
        self.id = id
    }
}
