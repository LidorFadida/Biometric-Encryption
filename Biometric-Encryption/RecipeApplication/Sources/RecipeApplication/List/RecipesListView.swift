//
//  RecipesListView.swift
//  RecipeApplication
//
//  Created by Lidor Fadida on 24/11/2024. 22/11/2024.
//

import Recipes
import Common
import SwiftUI

public struct RecipesListView<ViewModel: ObservableRecipesListViewModelProtocol>: View {
    @StateObject private var viewModel: ViewModel
    
    public init(viewModel: ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .center, spacing: 12.0) {
                switch viewModel.state {
                case .loading:
                    loadingView
                        .frame(width: proxy.size.width, height: proxy.size.height)
                case let .fetched(recipes):
                    ScrollView(.horizontal) {
                        recipesList(recipes: recipes, proxy: proxy)
                    }
                case .fetchFailed:
                    fetchingFailedView
                        .frame(width: proxy.size.width, height: proxy.size.height)
                }
            }
        }
        .task {
            viewModel.start()
        }
    }
    
    private var loadingView: some View {
        VStack(spacing: 20.0) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(1.5)
            
            Text("Loading...")
                .foregroundColor(.white)
                .font(.headline)
        }
    }
    
    private func recipesList(recipes: [RecipesListProperties.Recipe], proxy: GeometryProxy) -> some View {
        LazyHStack(spacing: proxy.size.width * 0.05) {
            ForEach(recipes) { recipe in
                let configuration = RecipeItemViewConfiguration(
                    name: recipe.name,
                    fats: recipe.fats,
                    calories: recipe.calories,
                    carbos: recipe.carbos,
                    image: recipe.thumb)
                RecipeItemView(configuration: configuration)
                    .frame(width: proxy.size.width * 0.9, height: proxy.size.height * 0.9)
                    .compositingGroup()
                    .clipShape(cellShape)
                    .contentShape(cellShape)
                    .shadow(color: .primary.opacity(0.5), radius: 4.0)
                    .padding(.vertical, 12.0)
                    .onTapGesture {
                        Task {
                            await viewModel.didTap(recipe: recipe)
                        }
                    }
            }
        }
    }
    
    private var cellShape: some Shape {
        return RoundedRectangle(cornerRadius: 24.0)
    }
    
    private var fetchingFailedView: some View {
        VStack(spacing: 20.0) {
            Image(uiImage: UIImage(systemName: "x.circle.fill") ?? .init())
                .resizable()
            Text("Failed")
                .foregroundColor(.white)
                .font(.headline)
        }
    }
    
}
