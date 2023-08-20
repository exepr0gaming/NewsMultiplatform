//
//  ArticleSearchViewModel.swift
//  NewsMultiplatform
//
//  Created by Andrew Kurdin on 12.08.2023.
//

import SwiftUI
import Combine // for tvOS

@MainActor
class ArticleSearchViewModel: ObservableObject {
  @Published var phase: DataFetchPhase<[Article]> = .empty
  @Published var searchQuery = ""
  @Published var history = [String]()
  @Published var currentSearch: String?
  private let newsAPI = NewsAPI.shared
  
  private let historyDataStore = PlistDataStore<[String]>(filename: "histories")
  private let historyMaxLimit = 10
  
  #if os(tvOS)
  private var cancellables = Set<AnyCancellable>()
  #endif
  static let shared = ArticleSearchViewModel()
  
  private var trimmedSearchQuery: String {
      searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
  }
  
  private init() {
    load()
#if os(tvOS)
    observeSearchQuery()
    #endif
  }
  
#if os(tvOS)
  private func observeSearchQuery() {
    $searchQuery
      .debounce(for: 1, scheduler: DispatchQueue.main)
      .sink { _ in
        Task { [weak self] in
          guard let self else { return }
          await self.searchArticle() }
      }
      .store(in: &cancellables)
  }
#endif
  
  func addHistory(_ text: String) {
    if let index = history.firstIndex(where: { text.lowercased() == $0.lowercased() }) {
      history.remove(at: index)
    } else if history.count == historyMaxLimit {
      history.remove(at: 0)
    }
    
    history.insert(text, at: 0)
    historiesUpdated()
  }
  
  func removeHistory(_ text: String) {
    guard let index = history.firstIndex(where: { text.lowercased() == $0.lowercased() })
    else { return }
    history.remove(at: index)
    historiesUpdated()
  }
  
  func removeAllHistory() {
    history.removeAll()
    historiesUpdated()
  }
  
  func searchArticle() async {
    if Task.isCancelled { return }
    let searchQuery = trimmedSearchQuery
    phase = .empty
    
    if searchQuery.isEmpty { return }
    
    currentSearch = searchQuery // for macOS
    do {
      let articles = try await newsAPI.search(for: searchQuery)
      if Task.isCancelled { return }
      if searchQuery != trimmedSearchQuery { return }
      phase = .success(articles)
    } catch {
      if Task.isCancelled { return }
      if searchQuery != trimmedSearchQuery { return }
      phase = .failure(error)
    }
  }
  
  private func load() {
    Task {
      history = await historyDataStore.load() ?? []
    }
  }
  
  private func historiesUpdated() {
    //let history = self.history // for what?
    Task {
      await historyDataStore.save(history)
    }
  }
  
}
