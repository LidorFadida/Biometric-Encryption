//
//  RecipeItemView.swift
//  Recipes
//
//  Created by Lidor Fadida on 24/11/2024.
//

import Extensions
import SDWebImageSwiftUI
import SwiftUI

public struct RecipeItemView: View {
    let configuration: RecipeItemViewConfiguration
    
    public init(configuration: RecipeItemViewConfiguration) {
        self.configuration = configuration
    }
    
    public var body: some View {
        ZStack {
            WebImage(url: URL(string: configuration.image))
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .overlay(Color.black.opacity(0.5))
            
            VStack(alignment: .leading, spacing: 8.0) {
                Color.clear
                
                Text(configuration.name)
                    .multilineTextAlignment(.leading)
                    .font(.from(uiFont: .boldSystemFont(ofSize: 24.0)))
                    .foregroundStyle(Color.white)
                    .padding(8.0)
                
                capsulesGrid
                    .fixedSize()
            }
            .padding(.horizontal, 12.0)
            .padding(.bottom, 24.0)
        }
    }
    
    private var capsulesGrid: some View {
        let items = ["Fats \(configuration.fats)",
                     "Carbos \(configuration.carbos)",
                     "Calories \(configuration.calories)"]
            .compactMap { text in
                return TextCapsuleGridItemConfiguration(text: text)
            }
        return TextCapsulesGridView(items: items)
    }
}
