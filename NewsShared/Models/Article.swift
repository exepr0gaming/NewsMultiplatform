//
//  Article.swift
//  NewsMultiplatform
//
//  Created by Andrew Kurdin on 09.08.2023.
//

import Foundation

fileprivate let relativeDateTimeFormatter = RelativeDateTimeFormatter()

// MARK: - Welcome
struct NewsAPIResponse: Codable {
  let status: String
  let totalResults: Int?
  let articles: [Article]?
  
  let code: String?
  let message: String?
}

// MARK: - Article
struct Article: Codable, Equatable, Identifiable {
  var id: String { url }
  
  let source: Source
  let author: String?
  let title: String
  let description: String?
  let url: String
  let urlToImage: String?
  let publishedAt: Date
  let content: String?
  
  var getSourceNameAndDate: String { "\(source.name) · \(relativeDateTimeFormatter.localizedString(for: publishedAt, relativeTo: Date()))" }
  var authorText: String { author ?? "" }
  var getDescription: String { description ?? "" }
  var articleURL: URL { URL(string: url)! }
  var getImageUrl: URL? {
    guard let urlToImage else { return nil }
    return URL(string: urlToImage)
  }
  var getContent: String { content ?? "" }
}

// MARK: - Source
struct Source: Codable, Equatable {
  let id: String?
  let name: String
}

// MARK: - For Tests
extension Article {
  static var previewData: [Article] {
    let previewDataURL = Bundle.main.url(forResource: "news", withExtension: "json")!
    let data = try! Data(contentsOf: previewDataURL)
    
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    let apiResponse = try! decoder.decode(NewsAPIResponse.self, from: data)
    
    return apiResponse.articles ?? []
  }
  
  static var previewCategoryArticles: [CategoryArticles] {
    let articles = previewData
    return Category.allCases.map {
      .init(category: $0, articles: articles.shuffled())
    }
  }
}
