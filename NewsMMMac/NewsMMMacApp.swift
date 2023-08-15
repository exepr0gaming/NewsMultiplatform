//
//  NewsMMMacApp.swift
//  NewsMMMac
//
//  Created by Andrew Kurdin on 14.08.2023.
//

import SwiftUI

@main
struct NewsMMMacApp: App {
  
  @StateObject private var bookmarkVM = ArticleBookmarkViewModel.shared
  @StateObject private var searchVM = ArticleSearchViewModel.shared
  
    var body: some Scene {
        WindowGroup {
            ContentView()
            .environmentObject(bookmarkVM)
            .environmentObject(searchVM)
        }
        .commands {
          SidebarCommands() // позволяет вкл sidebar, view -> Show sidebar
          NewsCommands()
        }
      
      // MARK: - Настройки приложения, которые открываются через settings симулятора
      Settings {
        SettingsView()
          .environmentObject(bookmarkVM)
          .environmentObject(searchVM)
      }
    }
}
