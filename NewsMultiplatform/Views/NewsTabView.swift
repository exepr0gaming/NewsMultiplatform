//
//  NewsTabView.swift
//  NewsMultiplatform
//
//  Created by Andrew Kurdin on 10.08.2023.
//

import SwiftUI

struct NewsTabView: View {
  
  @StateObject var articleNewsVM = ArticlesViewModel()
  
    var body: some View {
      NavigationView {
        ArticleListView(articles: articles)
          .overlay(overlayView)
          .onAppear {
            Task {
              print("@@@ Task")
              await articleNewsVM.loadArticles()
            }
          }
        
          .navigationTitle(articleNewsVM.selectedCategory.text)
      }
    }
  
  @ViewBuilder
  private var overlayView: some View {
    switch articleNewsVM.phase {
    case .empty:
      ProgressView()
    case .success(let articles) where articles.isEmpty:
       EmptyPlaceholderView(text: "No articles", image: nil)
    case .failure(let error):
       RetryView(text: error.localizedDescription) {
        // TODO: Refresh
      }
    default:  EmptyView()
    }
  }
  
  private var articles: [Article] {
    if case let .success(articles) = articleNewsVM.phase {
      return articles
    } else { return [] }
  }
  
}

struct NewsTabView_Previews: PreviewProvider {
    static var previews: some View {
        NewsTabView()
    }
}
