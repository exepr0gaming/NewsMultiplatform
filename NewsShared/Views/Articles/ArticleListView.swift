//
//  ArticleListView.swift
//  NewsMultiplatform
//
//  Created by Andrew Kurdin on 09.08.2023.
//

import SwiftUI

struct ArticleListView: View {
  
#if os(iOS)
  @Environment(\.horizontalSizeClass) private var horizontalSizeClass
  @State private var selectedArticle: Article?
#elseif os(macOS)
  @Environment(\.colorScheme) private var colorScheme
#endif
  let articles: [Article]
  
  var body: some View {
    rootView
#if os(iOS)
      .sheet(item: $selectedArticle) {
        SafariView(url: $0.articleURL)
          .edgesIgnoringSafeArea(.bottom)
      }
#endif
  }
  
#if os(iOS) || os(watchOS)
  private var listView: some View {
    List {
      ForEach(articles) { article in
#if os(iOS)
        ArticleRowView(article: article)
          .onTapGesture {
            selectedArticle = article
          }
#elseif os(watchOS)
        NavigationLink {
          Text(article.getDescription)
        } label: {
          ArticleRowView(article: article)
        }
#endif
      }
#if os(iOS)
      .listRowSeparator(.hidden)
#endif
    }
    .listStyle(.plain)
  }
#endif
  
  // MARK: - Список статей
  private var gridView: some View {
    ScrollView {
      LazyVGrid(columns: gridItems) {
        ForEach(articles) { article in
          ArticleRowView(article: article)
            .onTapGesture {
              handleOnTapGesture(article: article)
            }
#if os(iOS)
            .frame(height: 360)
            .background(Color(uiColor: .systemBackground))
#elseif os(macOS)
            .frame(height: 376)
            .background(Color(nsColor: colorScheme == .light ? .textBackgroundColor : .windowBackgroundColor))
#endif
            .mask(RoundedRectangle(cornerRadius: 8))
            .shadow(radius: 4)
            .padding(.bottom, 4)
        }
      }
      .padding()
    }
#if os(iOS)
    .background(Color(uiColor: .secondarySystemGroupedBackground))
#endif
  }
  
  private var gridItems: [GridItem] {
    #if os(iOS)
    [GridItem(.adaptive(minimum: 300), spacing: 8)]
    #else
    [GridItem(.adaptive(minimum: 272, maximum: 272), spacing: 8)]
    
    #endif
  }
  
  private func handleOnTapGesture(article: Article) {
#if os(iOS)
    self.selectedArticle = article
#elseif os(macOS)
    NSWorkspace.shared.open(article.articleURL)
#endif
  }
  
  @ViewBuilder
  private var rootView: some View {
#if os(iOS)
    switch horizontalSizeClass {
    case .regular:
      gridView
    default:
      listView
    }
#elseif os(macOS)
    gridView
#elseif os(watchOS)
    listView
#endif
  }
}

struct ArticleListView_Previews: PreviewProvider {
  @StateObject static var articleBookmarkVM = ArticleBookmarkViewModel.shared
  
  static var previews: some View {
    ArticleListView(articles: Article.previewData)
      .environmentObject(articleBookmarkVM)
  }
}
