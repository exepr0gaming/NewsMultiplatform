//
//  CacheImplementation.swift
//  NewsMultiplatform
//
//  Created by Andrew Kurdin on 21.08.2023.
//

import SwiftUI

actor CacheImplementation<V> { // ссылочный тип без наследования
  private let cache: NSCache<NSString, CacheEntry<V>> = .init()
  private let expirationIntermal: TimeInterval
  
  init(expirationIntermal: TimeInterval) {
    self.expirationIntermal = expirationIntermal
  }
  
  func removeValue(key: String) {
    cache.removeObject(forKey: key as NSString)
  }
  
  func removeAllValues() {
    cache.removeAllObjects()
  }
  
  func setValue(_ value: V?, key: String) {
    if let value {
      let expiredTimestamp = Date().addingTimeInterval(expirationIntermal)
      let cacheEntry = CacheEntry(key: key, value: value, expiredTimestamp: expiredTimestamp)
      cache.setObject(cacheEntry, forKey: key as NSString)
    } else {
      removeValue(key: key)
    }
  }
  
  func value(forKey key: String) -> V? {
    guard let entry = cache.object(forKey: key as NSString) else { return nil }
    guard !entry.isCacheExpired(after: Date()) else {
      removeValue(key: key)
      return nil
    }
    
    return entry.value
  }
  
}
