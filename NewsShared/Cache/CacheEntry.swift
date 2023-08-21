//
//  CacheEntry.swift
//  NewsMultiplatform
//
//  Created by Andrew Kurdin on 21.08.2023.
//

import SwiftUI

final class CacheEntry<V> {
  let key: String
  let value: V
  let expiredTimestamp: Date
  
  init(key: String, value: V, expiredTimestamp: Date) {
    self.key = key
    self.value = value
    self.expiredTimestamp = expiredTimestamp
  }
  
  func isCacheExpired(after date: Date = .now) -> Bool {
    date > expiredTimestamp
  }
}
