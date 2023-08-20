//
//  ArticleItemView.swift
//  NewsMultiplatform
//
//  Created by Andrew Kurdin on 20.08.2023.
//

import SwiftUI

struct ArticleItemView: View {
  let article: Article
  @EnvironmentObject private var bookmarkVM: ArticleBookmarkViewModel
  
    var body: some View {
      GeometryReader { proxy in
        let size = proxy.size
        
        VStack(alignment: .leading, spacing: 24) {
          asyncImage
            .frame(height: size.height * 0.6)
            .background(.gray.opacity(0.6))
            .clipped()
          
          VStack(alignment: .leading) {
            Text(article.title)
              .font(.subheadline)
              .foregroundStyle(.primary)
              .lineLimit(3)
            
            Spacer(minLength: 12)
            
            HStack {
              Text(article.source.name)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)
              
              if bookmarkVM.isBookmarked(for: article) {
                Spacer()
                Image(systemName: "bookmark.fill")
              }
            }
            
            
          }
          .padding([.horizontal, .bottom])
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
  }
  
}

struct ArticleItemView_Previews: PreviewProvider {
    static var previews: some View {
      ArticleItemView(article: Article.previewData[1])
        .environmentObject(ArticleBookmarkViewModel.shared)
        .frame(width: 400, height: 400)
    }
}
