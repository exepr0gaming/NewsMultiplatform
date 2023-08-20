//
//  ArticleCategoriesViewModel.swift
//  NewsTV
//
//  Created by Andrew Kurdin on 20.08.2023.
//

import SwiftUI

@MainActor // not need use maindispatch queue
class ArticleCategoriesViewModel: ObservableObject {
  @Published var phase = DataFetchPhase<[CategoryArticles]>.empty
  
  private let newsAPI = NewsAPI.shared
  
  var categoryArticles: [CategoryArticles] {
    phase.value ?? []
  }
  
  func loadCategoryArticles() async {
    phase = .success(Article.previewCategoryArticles)
//    if Task.isCancelled { return }
//    phase = .empty
//
//    do {
//      let categoryActicles = try await newsAPI.fetchAllCategoryArticles()
//      if Task.isCancelled { return }
//      phase = .success(categoryActicles)
//    } catch {
//      if Task.isCancelled { return }
//      phase = .failure(error)
//    }
  }
}
