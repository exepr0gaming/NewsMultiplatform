//
//  SettingsView.swift
//  NewsMMMac
//
//  Created by Andrew Kurdin on 15.08.2023.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
      TabView {
        GeneralSettings()
          .tabItem {
            Label("General", systemImage: "gear")
          }
      }
      .frame(width: 400, height: 100, alignment: .center)
    }
  
  private struct GeneralSettings: View {
    @EnvironmentObject var searchVM: ArticleSearchViewModel
    @EnvironmentObject var bookmarkVM: ArticleBookmarkViewModel
    
    var body: some View {
      Form {
        VStack {
          HStack {
            Text("Search history data: ")
              .frame(width: 150, alignment: .trailing)
            
            Button("Clear all") {
              searchVM.removeAllHistory()
            }
            .frame(alignment: .trailing)
          }
          
          HStack {
            Text("Saved bookmarks data: ")
              .frame(width: 150, alignment: .trailing)
            
            Button("Clear all") {
              bookmarkVM.removeAllBookmarks()
            }
            .frame(alignment: .trailing)
          }
        }
      }
      .fixedSize()
      .padding()
    }
  }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
