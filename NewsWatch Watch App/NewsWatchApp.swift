//
//  NewsWatchApp.swift
//  NewsWatch Watch App
//
//  Created by Andrew Kurdin on 15.08.2023.
//

import SwiftUI

@main
struct NewsWatch_Watch_AppApp: App {
  
  @StateObject private var bookmarkVM = ArticleBookmarkViewModel.shared
  @StateObject private var searchVM = ArticleSearchViewModel.shared
  @StateObject private var connectivityVM = WatchConnectivityViewModel.shared
  
    var body: some Scene {
        WindowGroup {
          NavigationView {
            ContentView()
          }
          .environmentObject(bookmarkVM)
          .environmentObject(searchVM)
          .environmentObject(connectivityVM)
        }
    }
}
