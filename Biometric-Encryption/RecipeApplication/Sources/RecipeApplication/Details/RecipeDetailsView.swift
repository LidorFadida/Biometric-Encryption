//
//  RecipeDetailsView.swift
//  RecipeApplication
//
//  Created by Lidor Fadida on 24/11/2024. 22/11/2024.
//

import Common
import SwiftUI

struct RecipeDetailsView<ViewModel: ObservableRecipeDetailsViewModelProtocol>: View {
    @StateObject private var viewModel: ViewModel
    
    public init(viewModel: ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
   
    public var body: some View {
        GeometryReader { proxy in
            switch viewModel.state {
            case .loading:
                EmptyView()
            case let .decrypted(itemViewConfiguration, description):
                decryptedView(itemViewConfiguration: itemViewConfiguration, description: description, proxy: proxy)
            }
        }
        .task {
            viewModel.start()
        }
    }
    
    private func decryptedView(itemViewConfiguration: RecipeItemViewConfiguration, description: String, proxy: GeometryProxy) -> some View {
        ScrollView {
            VStack(alignment: .center, spacing: 12.0) {
                RecipeItemView(configuration: itemViewConfiguration)
                    .frame(maxWidth: .infinity)
                    .frame(height: proxy.size.height * 0.7)
                Text(description)
                    .font(.from(uiFont: .systemFont(ofSize: 24.0, weight: .medium)))
                    .padding(12.0)
            }
        }
    }
}
