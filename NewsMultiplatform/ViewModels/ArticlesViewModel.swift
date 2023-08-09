//
//  ArticlesViewModel.swift
//  NewsMultiplatform
//
//  Created by Andrew Kurdin on 09.08.2023.
//

import SwiftUI

enum DataFetchPhase<T> {
  case empty
  case success(T)
  case failure(Error)
}

@MainActor // alternative Main async dispatch queue
class ArticlesViewModel: ObservableObject {
  @Published var phase = DataFetchPhase<[Article]>.empty
  @Published var selectedCategory: Category
  private let newsAPI = NewsAPI.shared
  
  init(articles: [Article]? = nil, selectedCategory: Category = .general) {
    if let articles = articles {
      self.phase = .success(articles)
    } else {
      self.phase = .empty
    }
    self.selectedCategory = selectedCategory
  }
  
  func loadArticles() async {
    phase = .empty
    do {
      let articles = try await newsAPI.fetch(from: selectedCategory)
      phase = .success(articles)
    } catch {
      print(error.localizedDescription)
      phase = .failure(error)
    }
  }
 
}
