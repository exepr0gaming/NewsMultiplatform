//
//  SearchTabView.swift
//  NewsMultiplatform
//
//  Created by Andrew Kurdin on 12.08.2023.
//

import SwiftUI

struct SearchTabView: View {
  
#if os(iOS)
  @Environment(\.horizontalSizeClass) private var horizontalSizeClass
#endif
  
#if os(iOS) || os(tvOS)
  @StateObject var searchVM = ArticleSearchViewModel.shared
#elseif os(macOS) || os(watchOS)
  @EnvironmentObject var searchVM: ArticleSearchViewModel
#endif
  
  var body: some View {
    ArticleListView(articles: articles)
      .overlay(overlayView)
#if os(iOS)
      .navigationTitle("Search")
      .searchable(text: $searchVM.searchQuery, placement: horizontalSizeClass == .regular ? .navigationBarDrawer : .automatic) {
        if searchVM.searchQuery.isEmpty {
          suggestionsView // добавляет список тегов к поиску при нажатии
        } else {
          EmptyView() // иначе страница не обновляется
        }
      }
      .onChange(of: searchVM.searchQuery, perform: { newValue in
        if newValue.isEmpty {
          searchVM.phase = .empty
        } // сбрасывает страницу, если строка поиска пуста (такое себе)
      })
      .onSubmit(of: .search, search) // срабатывает при нажатии search на клавиатуре, а не при вводе
    #elseif os(tvOS)
      .searchable(text: $searchVM.searchQuery)
      .onChange(of: searchVM.searchQuery, perform: { newValue in
        if newValue.isEmpty {
          searchVM.phase = .empty
        } // сбрасывает страницу, если строка поиска пуста (такое себе)
      })
      //.onSubmit(of: .search, search) for tvOS не работает, там combine
    
#elseif os(macOS) || os(watchOS)
      .navigationTitle(searchVM.currentSearch == nil ? "Search" : "Search results for \(searchVM.currentSearch!)")
#endif
  }
  
  private var articles: [Article] {
    if case .success(let articles) = searchVM.phase {
      return articles
    } else {
      return []
    }
  }
  
  @ViewBuilder
  private var overlayView: some View {
    switch searchVM.phase {
    case .empty:
#if os(iOS)
      if !searchVM.searchQuery.isEmpty {
        ProgressView()
      } else if !searchVM.history.isEmpty {
        SearchHistoryListView(searchVM: searchVM) { newValue in
          searchVM.searchQuery = newValue
        }
      } else {
        EmptyPlaceholderView(text: "Type your query to search from News API", image: Image(systemName: "magnifyingglass"))
      }
      #elseif os(tvOS)
      if !searchVM.searchQuery.isEmpty {
        ProgressView()
      } else {
        EmptyPlaceholderView(text: "Type your query to search from News API", image: Image(systemName: "magnifyingglass"))
      }
#elseif os(macOS) || os(watchOS)
      ProgressView()
#endif
    case .success(let articles) where articles.isEmpty:
      EmptyPlaceholderView(text: "No search results found", image: Image(systemName: "magnifyingglass"))
    case .failure(let error):
      RetryView(text: error.localizedDescription) {
        search()
      }
    default: EmptyView()
    }
  }
  
  @ViewBuilder
  private var suggestionsView: some View {
    ForEach(["Swift", "BTC", "IOS"], id: \.self) { tag in
      Button {
        searchVM.searchQuery = tag
        print("searchVM.searchQuery2=\(searchVM.searchQuery)")
      } label: {
        Text(tag)
      }
    }
  }
  
  private func search() {
    let searchQuery = searchVM.searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
    if !searchQuery.isEmpty {
      searchVM.addHistory(searchQuery)
    }
    
    Task {
      await searchVM.searchArticle()
    }
  }
}

struct SearchTabView_Previews: PreviewProvider {
  
  @StateObject static var searchVM = ArticleSearchViewModel.shared
  static var previews: some View {
    SearchTabView()
      .environmentObject(searchVM)
  }
}
