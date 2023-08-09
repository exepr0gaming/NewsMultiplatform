//
//  ArticleRowView.swift
//  NewsMultiplatform
//
//  Created by Andrew Kurdin on 09.08.2023.
//

import SwiftUI

struct ArticleRowView: View {
  let article: Article
  
  var body: some View {
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
      .frame(width: UIScreen.main.bounds.width)//, height: 300)
      .frame(minHeight: 200, maxHeight: 300)
      .clipped()
      
      
      VStack(alignment: .leading, spacing: 8) {
        Text(article.title)
          .font(.headline)
          .lineLimit(3)
        
        Text(article.getDescription)
          .font(.subheadline)
          .lineLimit(3)
        
        HStack {
          Text(article.getSourceNameAndDate)
            .foregroundStyle(.secondary)
            .font(.caption)
          
          Spacer()
          
          Button {
            //
          } label: {
            Image(systemName: "bookmark")
          }
          .buttonStyle(.bordered)
          
          Button {
            presentShareSheet(url: article.articleURL)
          } label: {
            Image(systemName: "square.and.arrow.up")
          }
          .buttonStyle(.bordered)

          
        }
      }
      .padding([.horizontal, .bottom])
    }
  }
}

struct ArticleRowView_Previews: PreviewProvider {
  static var previews: some View {
    ArticleListView(articles: Article.previewData)
  }
}
