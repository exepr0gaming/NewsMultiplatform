//
//  ArticleListView.swift
//  NewsMultiplatform
//
//  Created by Andrew Kurdin on 09.08.2023.
//

import SwiftUI

struct ArticleListView: View {
  let articles: [Article]
  @State private var selectedArticle: Article?
  
    var body: some View {
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
      .sheet(item: $selectedArticle) {
        SafariView(url: $0.articleURL)
          .edgesIgnoringSafeArea(.bottom)
      }
    }
}

struct ArticleListView_Previews: PreviewProvider {
    static var previews: some View {
      ArticleListView(articles: Article.previewData)
    }
}
