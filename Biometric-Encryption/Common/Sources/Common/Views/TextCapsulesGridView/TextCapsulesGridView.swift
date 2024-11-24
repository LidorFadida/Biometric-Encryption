//
//  TextCapsulesGridView.swift
//  Common
//
//  Created by Lidor Fadida on 24/11/2024. 22/11/2024.
//

import SwiftUI

public struct TextCapsulesGridView: View {
    private let items: [TextCapsuleGridItemConfiguration]
    private let rowSpacing: CGFloat
    
    public init(items: [TextCapsuleGridItemConfiguration], rowSpacing: CGFloat = 12.0) {
        self.items = items
        self.rowSpacing = rowSpacing
    }
    
    public var body: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 0.0, alignment: .leading),
                GridItem(.flexible(), spacing: 0.0, alignment: .leading)
            ],
            spacing: rowSpacing
        ) {
            ForEach(items) { item  in
                textCapsule(text: item.text)
                    .fixedSize()
            }
        }
    }

    private func textCapsule(text: String) -> some View {
        Text(text)
            .font(.from(uiFont: .systemFont(ofSize: 18.0)))
            .multilineTextAlignment(.center)
            .lineLimit(1)
            .foregroundStyle(Color.white)
            .padding(.vertical, 8.0)
            .padding(.horizontal, 12.0)
            .frame(maxWidth: .infinity)
            .background(
                Capsule()
                    .fill(Color.lightGray.opacity(0.3))
            )
    }
}
