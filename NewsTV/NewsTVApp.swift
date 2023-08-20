//
//  NewsTVApp.swift
//  NewsTV
//
//  Created by Andrew Kurdin on 20.08.2023.
//

import SwiftUI

@main
struct NewsTVApp: App {
  @StateObject private var bookmarkVM = ArticleBookmarkViewModel.shared
  
  var body: some Scene {
    WindowGroup {
      NavigationView {
        ContentView()
      }
      .environmentObject(bookmarkVM)
    }
  }
}
