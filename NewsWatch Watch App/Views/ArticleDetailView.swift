//
//  ArticleDetailView.swift
//  NewsWatch Watch App
//
//  Created by Andrew Kurdin on 17.08.2023.
//

import SwiftUI

struct ArticleDetailView: View {
  let article: Article
  @EnvironmentObject private var bookmarkVM: ArticleBookmarkViewModel
  @EnvironmentObject private var connectivityVM: WatchConnectivityViewModel
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 8) {
        Text(article.title)
          .font(.headline)
          .foregroundStyle(.primary)
        
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
        .cornerRadius(4)
        .clipped()
        
        HStack {
            Button {
                bookmarkVM.toggleBookmark(for: article)
            } label: {
                Image(systemName: bookmarkVM.isBookmarked(for: article) ? "bookmark.fill" : "bookmark")
                    .imageScale(.large)
            }
            
            if connectivityVM.isReachable {
                if connectivityVM.isSending {
                    ProgressView()
                        .frame(height: 20)
                } else {
                    Button {
                        connectivityVM.sendURLToiPhone(article: article)
                    } label: {
                        Image(systemName: "arrow.turn.up.forward.iphone")
                            .imageScale(.large)
                    }
                }
            }
        }
        
        Text(article.getDescription)
          .font(.body)
          .foregroundStyle(.secondary)
        
        Text(article.getSourceNameAndDate)
          .font(.caption)
          .foregroundStyle(.tertiary)
      }
    }
  }
}

struct ArticleDetailView_Previews: PreviewProvider {
  static var previews: some View {
    ArticleDetailView(article: Article.previewData[0])
      .environmentObject(ArticleBookmarkViewModel.shared)
      .environmentObject(WatchConnectivityViewModel.shared)
  }
}
