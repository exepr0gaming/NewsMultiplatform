//
//  ArticleBookmarkViewModel.swift
//  NewsMultiplatform
//
//  Created by Andrew Kurdin on 10.08.2023.
//

import SwiftUI

@MainActor
class ArticleBookmarkViewModel: ObservableObject {
  @Published private(set) var bookmarks: [Article] = []
  private let bookmarkStore = PlistDataStore<[Article]>(filename: "bookmarks")
  static let shared = ArticleBookmarkViewModel()
  private init() {
    Task { await asyncLoad() }
  }
  
  private func asyncLoad() async {
    bookmarks = await bookmarkStore.load() ?? []
  }
  
  private func bookmarkUpdated() {
    let bookmarks = self.bookmarks
    Task {
      await bookmarkStore.save(bookmarks)
    }
  }
  
  func isBookmarked(for article: Article) -> Bool {
    bookmarks.first { article.id == $0.id } != nil
  }
  
  func addBookmark(for article: Article) {
    guard !isBookmarked(for: article) else { return }
    bookmarks.insert(article, at: 0)
    bookmarkUpdated()
  }
  
  func removeBookmark(for article: Article) {
    guard let index = bookmarks.firstIndex(where: { $0.id == article.id }) else { return }
    bookmarks.remove(at: index)
    bookmarkUpdated()
  }
  
  func removeAllBookmarks() {
    bookmarks.removeAll()
    bookmarkUpdated()
  }
  
  func toggleBookmark(for article: Article) {
    if isBookmarked(for: article) {
      removeBookmark(for: article)
    } else {
      addBookmark(for: article)
    }
  }
  
}
