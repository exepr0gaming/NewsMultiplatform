//
//  ArticleCarouselView.swift
//  NewsMultiplatform
//
//  Created by Andrew Kurdin on 20.08.2023.
//

import SwiftUI

struct ArticleCarouselView: View {
  @EnvironmentObject private var bookmarkVM: ArticleBookmarkViewModel
  
  let title: String
  let articles: [Article]
  
    var body: some View {
      VStack(alignment: .leading) {
        Text(title)
          .font(.headline)
          .foregroundStyle(.primary)
          .padding(.horizontal, 64)
        
        ScrollView(.horizontal) {
          LazyHStack(spacing: 32) {
            ForEach(articles) { article in
              NavigationLink {
                #if os(tvOS)
                TVArticleDetailView(article: article)
                #endif
              } label: {
                ArticleItemView(article: article)
                  .frame(width: 420, height: 420)
              }
              .buttonStyle(.card)
              .contextMenu {
                Button {
                  bookmarkVM.toggleBookmark(for: article)
                } label: {
                  Text(bookmarkVM.isBookmarked(for: article) ? "Remove Bookmark" : "Add Bookmark")
                }
              }

            }
          }
          .padding([.bottom, .horizontal], 64)
          .padding(.top, 32 )
        }
     
      }
    }
}

struct ArticleCarouselView_Previews: PreviewProvider {
    static var previews: some View {
      NavigationView {
        ArticleCarouselView(title: "Business", articles: Article.previewData)
          .environmentObject(ArticleBookmarkViewModel.shared)
      }
    }
}
