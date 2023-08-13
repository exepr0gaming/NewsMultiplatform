//
//  MainView.swift
//  NewsMultiplatform
//
//  Created by Andrew Kurdin on 09.08.2023.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
         NewsTabView()
            .tabItem {
              Label("News", systemImage: "newspaper")
            }
          
          SearchTabView()
            .tabItem {
              Label("Search", systemImage: "magnifyingglass")
            }
          
          BookmarkTabView()
            .tabItem {
              Label("Saved", systemImage: "bookmark")
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
