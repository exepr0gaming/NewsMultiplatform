//
//  ArticleRowView.swift
//  NewsMultiplatform
//
//  Created by Andrew Kurdin on 09.08.2023.
//

import SwiftUI

struct ArticleRowView: View {
  
  @Environment(\.horizontalSizeClass) private var horizontalSizeClass
  @EnvironmentObject var articleBookmarkVM: ArticleBookmarkViewModel
  let article: Article
  
  var body: some View {
    switch horizontalSizeClass {
    case .regular:
      GeometryReader { contentView(proxy: $0) }
    default:
      contentView()
    }
  }
  
  @ViewBuilder
  private func contentView(proxy: GeometryProxy? = nil) -> some View {
    VStack(alignment: .leading, spacing: 16) {
      AsyncImage(url: article.getImageUrl) { phase in
        switch phase {
        case .empty:
          ProgressView()
        case .success(let image):
          image
            .resizable()
            .scaledToFill()
          
        case .failure(_):
          ZStack {
            Image(systemName: "photo")
              .resizable()
              .scaledToFit()
              .padding()
              .opacity(0.05)
            
            Text("Error Loading image")
          }
        @unknown default:
          Text("Error load image")
        }
      }
      .asyncImageFrame(horizontalSizeClass: horizontalSizeClass ?? .compact)
      .clipped()
      
      
      VStack(alignment: .leading, spacing: 8) {
        Text(article.title)
          .font(.headline)
          .lineLimit(3)
        
        Text(article.getDescription)
          .font(.subheadline)
          .lineLimit(2)
        
        if horizontalSizeClass == .regular {
          Spacer()
        }
        
        HStack {
          Text(article.getSourceNameAndDate)
            .foregroundStyle(.secondary)
            .font(.caption)
          
          Spacer()
          
          Button {
            toogleBookmark(for: article)
          } label: {
            //Image(systemName: "bookmark")
            Image(systemName:articleBookmarkVM.isBookmarked(for: article) ? "bookmark.fill" : "bookmark")
          }
          .buttonStyle(.bordered)
          
          Button {
            presentShareSheet(url: article.articleURL, proxy: proxy)
          } label: {
            Image(systemName: "square.and.arrow.up")
          }
          .buttonStyle(.bordered)
        }
      }
      .padding([.horizontal, .bottom])
    }
  }
  
  private func toogleBookmark(for article: Article) {
    if articleBookmarkVM.isBookmarked(for: article) {
      articleBookmarkVM.removeBookmark(for: article)
    } else {
      articleBookmarkVM.addBookmark(for: article)
    }
  }
}

fileprivate extension View {
  @ViewBuilder
  func asyncImageFrame(horizontalSizeClass: UserInterfaceSizeClass) -> some View {
    switch horizontalSizeClass {
    case .regular:
      frame(height: 180)
    default:
      frame(minHeight: 200, maxHeight: 300)
    }
  }
}

struct ArticleRowView_Previews: PreviewProvider {
  @StateObject static var articleBookmarkVM = ArticleBookmarkViewModel.shared
  static var previews: some View {
    ArticleListView(articles: Article.previewData)
      .environmentObject(articleBookmarkVM)
  }
}
