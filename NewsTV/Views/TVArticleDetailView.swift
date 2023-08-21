//
//  TVArticleDetailView.swift
//  NewsTV
//
//  Created by Andrew Kurdin on 20.08.2023.
//

import SwiftUI

struct TVArticleDetailView: View {
  @EnvironmentObject private var bookmarkVM: ArticleBookmarkViewModel
  let article: Article
  
  var body: some View {
    VStack(alignment: .leading) {
      Text(article.title)
        .font(.title)
        .foregroundStyle(.primary)
        .padding(.bottom)
      
      Text(article.getSourceNameAndDate)
        .font(.subheadline)
        .padding(.bottom)
      
      detailView
    }
  }
  
  private var detailView: some View {
    HStack(alignment: .top) {
      asyncImage
      Spacer()
      ScrollView {
        VStack(alignment: .leading, spacing: 32) {
          Text(article.getDescription)
            .font(.headline)
          
          Text(article.url)
            .foregroundStyle(.secondary)
          
          Button {
            bookmarkVM.toggleBookmark(for: article)
          } label: {
            if bookmarkVM.isBookmarked(for: article) {
              Label("Remove from bookmark", systemImage: "bookmark.fill")
            } else {
              Label("Add Bookmark", systemImage: "bookmark")
            }
          }

        }
      }
    }
  }
  
  private var asyncImage: some View {
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
    .frame(minWidth: 400, minHeight: 400, maxHeight: 648)
    .background(Color.gray.opacity(0.6))
    .clipped()
    .cornerRadius(16)
  }
}

struct TVArticleDetailView_Previews: PreviewProvider {
    static var previews: some View {
      TVArticleDetailView(article: Article.previewData[1])
        .environmentObject(ArticleSearchViewModel.shared)
    }
}
