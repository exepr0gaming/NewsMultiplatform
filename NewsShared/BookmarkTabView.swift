//
//  BookmarkTabView.swift
//  NewsMultiplatform
//
//  Created by Andrew Kurdin on 12.08.2023.
//

import SwiftUI

struct BookmarkTabView: View {
  @EnvironmentObject var articleBookmarkVM: ArticleBookmarkViewModel
  @State var searchText: String = ""
  
  var body: some View {
   // let articles = self.articles // TODO: Bad decision , да и без него работает как бы(
    
   // NavigationView {
      ArticleListView(articles: articles) //articleBookmarkVM.bookmarks)
        .overlay { overlayView(isEmpty: articles.isEmpty) }
        .navigationTitle("Saved Articles")
   // }
    #if os(macOS)
        .navigationSubtitle("\(articles.count) bookmark(s)")
    #endif
    .searchable(text: $searchText)
  }
  
  private var articles: [Article] {
    if searchText.isEmpty { return articleBookmarkVM.bookmarks }
    return articleBookmarkVM.bookmarks
      .filter {
        $0.title.lowercased().contains(searchText.lowercased()) ||
        $0.getDescription.lowercased().contains(searchText.lowercased())
      }
  }
  
  @ViewBuilder
  func overlayView(isEmpty: Bool) -> some View {
    if isEmpty {
      EmptyPlaceholderView(text: "No saved articles", image: Image(systemName: "bookmark"))
    }
  }
}

struct BookmarkTabView_Previews: PreviewProvider {
    static var previews: some View {
        BookmarkTabView()
    }
}
