//
//  Font+Extensions.swift
//  Recipes
//
//  Created by Lidor Fadida on 24/11/2024.
//

import SwiftUI

public extension SwiftUI.Font {
    
    static func from(uiFont: UIFont) -> SwiftUI.Font {
        return SwiftUI.Font(uiFont as CTFont)
    }
}
