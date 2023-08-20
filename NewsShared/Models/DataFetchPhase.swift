//
//  DataFetchPhase.swift
//  NewsMultiplatform
//
//  Created by Andrew Kurdin on 20.08.2023.
//

import Foundation

enum DataFetchPhase<T> {
    case empty
    case success(T)
    case failure(Error)
  
  var value: T? {
    if case .success(let t) = self {
      return t
    }
    return nil
  }
}
