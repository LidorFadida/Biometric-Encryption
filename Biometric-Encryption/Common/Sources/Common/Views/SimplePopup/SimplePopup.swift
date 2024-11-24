//
//  SimplePopup.swift
//  Common
//
//  Created by Lidor Fadida on 24/11/2024.
//

import SwiftUI

///A super simple popup
public struct SimplePopup: View {
    @Environment(\.dismiss) var dismiss
    @State private var animate: Bool = false
    let message: String
    
    public init(message: String) {
        self.message = message
    }
    
    public var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let height = proxy.size.height
            ZStack(alignment: .center) {
                Color.black.opacity(0.2)
                content
                    .scaleEffect(x: animate ? 1.0 : 0.1 , y: animate ? 1.0 : 0.1)
                    .frame(width: width * 0.8)
                    .frame(maxHeight: height * 0.8)
                    .fixedSize(horizontal: false, vertical: true)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 26.0))
                    .shadow(color: .black.opacity(0.3), radius: 10.0)
                    .animation(.easeOut(duration: 0.4), value: animate)
                    .onAppear { animate.toggle() }
            }
            .frame(width: width, height: height)
        }
        
        .onTapGesture {
            dismiss()
        }
        .ignoresSafeArea(.all)
    }
    
    var content: some View {
        ZStack(alignment: .center) {
            VStack(alignment: .center, spacing: 0.0) {
                Text("Something went wrong")
                    .font(.system(size: 30.0, weight: .black))
                    .foregroundStyle(Color.black)
                    .padding()
                Rectangle()
                    .fill(Color.black)
                    .frame(height: 2.0)
                    .frame(maxWidth: .infinity)
                ScrollView {
                    Text(message)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 24.0, weight: .medium))
                        .foregroundStyle(Color.black)
                        .padding()
                }
            }
        }
    }
}

#Preview("Short") {
    SimplePopup(message: "Lorem Ipsum is simply like Aldus PageMaker including versions of Lorem Ipsum.")
}

#Preview("Long") {
    SimplePopup(message: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.")
}
