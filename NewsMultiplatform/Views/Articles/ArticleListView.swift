//
//  ArticleListView.swift
//  NewsMultiplatform
//
//  Created by Andrew Kurdin on 09.08.2023.
//

import SwiftUI

struct ArticleListView: View {
  
  @Environment(\.horizontalSizeClass) private var horizontalSizeClass
  let articles: [Article]
  @State private var selectedArticle: Article?
  
    var body: some View {
     rootView
      .sheet(item: $selectedArticle) {
        SafariView(url: $0.articleURL)
          .edgesIgnoringSafeArea(.bottom)
      }
    }
  
  private var listView: some View {
    List {
      ForEach(articles) { article in
        ArticleRowView(article: article)
          .onTapGesture {
            selectedArticle = article
          }
         // .padding(.bottom)
      }
      .listRowSeparator(.hidden)
    }
    .listStyle(.plain)
  }
  
  private var gridView: some View {
    ScrollView {
      LazyVGrid(columns: [GridItem(.adaptive(minimum: 300), spacing: 8)]) {
        ForEach(articles) { article in
          ArticleRowView(article: article)
            .onTapGesture {
              self.selectedArticle = article
            }
            .frame(height: 360)
            .background(Color(uiColor: .systemBackground))
            .mask(RoundedRectangle(cornerRadius: 8))
            .shadow(radius: 4)
            .padding(.bottom, 4)
        }
      }
      .padding()
    }
    .background(Color(uiColor: .secondarySystemGroupedBackground))
  }
  
  @ViewBuilder
  private var rootView: some View {
    switch horizontalSizeClass {
    case .regular:
      gridView
    default:
      listView
    }
  }
}

struct ArticleListView_Previews: PreviewProvider {
  @StateObject static var articleBookmarkVM = ArticleBookmarkViewModel.shared
 
    static var previews: some View {
        ArticleListView(articles: Article.previewData)
          .environmentObject(articleBookmarkVM)
    }
}
