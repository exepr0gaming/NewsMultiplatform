//
//  ArticleSearchViewModel.swift
//  NewsMultiplatform
//
//  Created by Andrew Kurdin on 12.08.2023.
//

import SwiftUI

@MainActor
class ArticleSearchViewModel: ObservableObject {
  @Published var phase: DataFetchPhase<[Article]> = .empty
  @Published var searchQuery = ""
  private let newsAPI = NewsAPI.shared
  
  func searchArticle() async {
    if Task.isCancelled { return }
    let searchQuery = self.searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
    phase = .empty
    
    if searchQuery.isEmpty { return }
    
    do {
      let articles = try await newsAPI.search(for: searchQuery)
      if Task.isCancelled { return }
      phase = .success(articles)
    } catch {
      if Task.isCancelled { return }
      phase = .failure(error)
    }
  }
 
}
