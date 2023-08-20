//
//  NewsAPI.swift
//  NewsMultiplatform
//
//  Created by Andrew Kurdin on 09.08.2023.
//

import Foundation

struct NewsAPI {
  
  static let shared = NewsAPI()
  private init() {}
  
  private let apiKey = "63ecf6c4a47c45e4a161941fa048bc33"
  private let session = URLSession.shared
  private let jsonDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    return decoder
  }()
  
  func fetch(from category: Category) async throws -> [Article] {
    try await fetchArticles(from: generateNewsURL(from: category))
  }
  
  func search(for query: String) async throws -> [Article] {
    try await fetchArticles(from: generateSearchURL(from: query))
  }
  
  private func fetchResult(from category: Category) async  -> Result<CategoryArticles, Error> {
    do {
      let articles = try await fetchArticles(from: generateNewsURL(from: category))
      return .success(CategoryArticles(category: category, articles: articles))
    } catch let error {
      return .failure(error)
    }
  }
  
  func fetchAllCategoryArticles() async throws -> [CategoryArticles] {
    try await withThrowingTaskGroup(of: Result<CategoryArticles, Error>.self) { group in
      for category in Category.allCases {
        group.addTask {
          await fetchResult(from: category)
        }
      }
      var results = [Result<CategoryArticles, Error>]()
      for try await result in group {
        results.append(result)
      }
      
      if let first = results.first,
         case .failure(let error) = first,
         (error as NSError).code == 401 {
        throw error
      }
      
      var categories = [CategoryArticles]()
      for result in results {
        if case .success(let success) = result {
          categories.append(success)
        }
      }
      
      categories.sort { $0.category.sortIndex < $1.category.sortIndex }
      return categories
    }
    
  }
  
  private func fetchArticles(from url: URL) async throws -> [Article] {
    let (data, response) = try await session.data(from: url)
    
    guard let response = response as? HTTPURLResponse else {
      throw generateError(description: "Bad Response")
    }
    
    switch response.statusCode {
      
    case (200...299), (400...499):
      print("@@@ response.statusCode=\(response.statusCode)")
      let apiResponse = try jsonDecoder.decode(NewsAPIResponse.self, from: data)
      if apiResponse.status == "ok" { // default from NewsAPI
        // print("\(apiResponse.articles)")
        return apiResponse.articles ?? []
      } else {
        let errorCode = response.statusCode == 401 ? 401 : 1
        print("@@@ ERROR response.statusCode=\(response.statusCode)")
        throw generateError(code: errorCode, description: "An error occured")
      }
      
    default:
      throw generateError(description: "Server error")
    }
  }
  
  private func generateError(code: Int = 1, description: String) -> Error {
    NSError(domain: "NewsAPI", code: code, userInfo: [NSLocalizedDescriptionKey: description])
  }
  
  private func generateSearchURL(from query: String) -> URL {
    let percentEncodedString = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
    let url = "https://newsapi.org/v2/everything?"
    + "apiKey=\(apiKey)"
    + "&language=en"
    + "&q=\(percentEncodedString)"
    return URL(string: url)!
  }
  
  private func generateNewsURL(from category: Category) -> URL {
    let url = "https://newsapi.org/v2/top-headlines?"
    + "apiKey=\(apiKey)"
    + "&language=en"
    + "&category=\(category.rawValue)"
    // (url +=) or (+) ?)
    //    print("@@@url=\(url)")
    //    print("@@url2=https://newsapi.org/v2/top-headlines?apiKey=63ecf6c4a47c45e4a161941fa048bc33&language=en&category=general")
    return URL(string: url)!
  }
  // country=us&category=business&apiKey=63ecf6c4a47c45e4a161941fa048bc33
}
