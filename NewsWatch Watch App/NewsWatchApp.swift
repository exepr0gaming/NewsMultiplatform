//
//  NewsWatchApp.swift
//  NewsWatch Watch App
//
//  Created by Andrew Kurdin on 15.08.2023.
//

import SwiftUI

@main
struct NewsWatch_Watch_AppApp: App {
  
  @State private var bookmarkVM = ArticleBookmarkViewModel.shared
  
    var body: some Scene {
        WindowGroup {
          NavigationView {
            ContentView()
          }
          .environmentObject(bookmarkVM)
        }
    }
}
