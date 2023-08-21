//
//  ArticlesViewModel.swift
//  NewsMultiplatform
//
//  Created by Andrew Kurdin on 09.08.2023.
//

import SwiftUI

struct FetchTaskToken: Equatable {
  var category: Category
  var token: Date
}

fileprivate let dateFormatter = DateFormatter()

@MainActor
class ArticleNewsViewModel: ObservableObject {
  
  
  @Published var phase: DataFetchPhase<[Article]> = .empty
  @Published var fetchTaskToken: FetchTaskToken {
    didSet {
      if oldValue.category != fetchTaskToken.category {
        selectedMenuItemId = MenuItem.category(fetchTaskToken.category).id
      }
    }
  }
  @AppStorage("selectedMenuItemId") private var selectedMenuItemId: MenuItem.ID?
  private let cache = CacheImplementation<[Article]>(expirationIntermal: 5 * 60)
  
  private let newsAPI = NewsAPI.shared
  
  var lastRefreshedDateText: String {
    dateFormatter.timeStyle = .short
    return "Last refreshed at: \(dateFormatter.string(from: fetchTaskToken.token))"
  }
  
  // интересно, init articles, selectedCategory without @Published
  init(articles: [Article]? = nil, selectedCategory: Category = .general) {
    if let articles = articles {
      self.phase = .success(articles)
    } else {
      self.phase = .empty
    }
    self.fetchTaskToken = FetchTaskToken(category: selectedCategory, token: Date())
  }
  
  func loadArticles() async {
    // phase = .success(Article.previewData)
    if Task.isCancelled { return }
    
    /// Чекаем кэш, если есть
    let category = fetchTaskToken.category
    if let articles = await cache.value(forKey: category.rawValue) {
      phase = .success(articles)
      print("@@@ Cache Hit")
      return
    }
    
    print("@@@ Cache Missed/Expired")
    phase = .empty
    
    do {
      let articles = try await newsAPI.fetch(from: fetchTaskToken.category)
      if Task.isCancelled { return }
      /// Устанавливаем кэш
      await cache.setValue(articles, key: category.rawValue)
      print("@@@ Cache SET")
      phase = .success(articles)
    } catch {
      if Task.isCancelled { return }
      print(error.localizedDescription)
      phase = .failure(error)
    }
  }
}
