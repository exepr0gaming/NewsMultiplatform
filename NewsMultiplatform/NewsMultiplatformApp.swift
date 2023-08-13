//
//  NewsMultiplatformApp.swift
//  NewsMultiplatform
//
//  Created by Andrew Kurdin on 09.08.2023.
//

import SwiftUI

@main
struct NewsMultiplatformApp: App {
  
  @StateObject var articleBookmarkVM = ArticleBookmarkViewModel.shared
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(articleBookmarkVM)
    }
  }
}
