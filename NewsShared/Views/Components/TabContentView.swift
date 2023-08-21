//
//  TabContentView.swift
//  NewsMultiplatform
//
//  Created by Andrew Kurdin on 13.08.2023.
//

import SwiftUI

struct TabContentView: View {
  
  @Binding var selectedMenuItemId: MenuItem.ID?
  private var selection: Binding<TabMenuItem> {
    Binding {
      TabMenuItem(menuItem: selectedMenuItemId)
    } set: { newValue in
      selectedMenuItemId = newValue.menuItemId(category: selectedCategory ?? .general)
    }
  }
  
  private var selectedCategory: Category? {
    let menuItem = MenuItem(id: selectedMenuItemId)
    if case .category(let category) = menuItem {
      return category
    } else {
      return nil
    }
  }
  
  var body: some View {
    TabView(selection: selection) {
      ForEach(TabMenuItem.allCases) { item in
        NavigationView {
          viewForTabItem(item)
        }
        .tabItem {
          Label(item.text, systemImage: item.systemImage)
        }
        .tag(item)
      }
    }
  }
  
  @ViewBuilder
  private func viewForTabItem(_ item: TabMenuItem) -> some View {
    switch item {
    case .search:
     
#if os(iOS) || os(macOS)
      SearchTabView()
   // .navigationSubtitle("\(articles.count) bookmark(s)")
#else
    SearchTabView()
#endif
    case .saved:
       BookmarkTabView()
      
    case .news:
#if os(iOS)
      NewsTabView(category: selectedCategory ?? .general)
#else
      NewsView()
        .edgesIgnoringSafeArea(.horizontal)
#endif
     
    }
  }
}

struct TabContentView_Previews: PreviewProvider {
  static var previews: some View {
    TabContentView(selectedMenuItemId: .constant(nil))
  }
}
