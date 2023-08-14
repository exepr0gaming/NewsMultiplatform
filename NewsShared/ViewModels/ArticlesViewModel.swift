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

struct FetchTaskToken: Equatable {
    var category: Category
    var token: Date
}

@MainActor
class ArticleNewsViewModel: ObservableObject {
  
  @AppStorage("selectedMenuItemId") private var selectedMenuItemId: MenuItem.ID?
    @Published var phase: DataFetchPhase<[Article]> = .empty
  @Published var fetchTaskToken: FetchTaskToken {
    didSet {
      if oldValue.category != fetchTaskToken.category {
        selectedMenuItemId = MenuItem.category(fetchTaskToken.category).id
      }
    }
  }
    private let newsAPI = NewsAPI.shared
    
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
        phase = .empty
        do {
            let articles = try await newsAPI.fetch(from: fetchTaskToken.category)
            if Task.isCancelled { return }
            phase = .success(articles)
        } catch {
            if Task.isCancelled { return }
            print(error.localizedDescription)
            phase = .failure(error)
        }
    }
}
