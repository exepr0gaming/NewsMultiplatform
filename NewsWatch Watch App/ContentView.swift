//
//  ContentView.swift
//  NewsWatch Watch App
//
//  Created by Andrew Kurdin on 15.08.2023.
//

import SwiftUI

struct ContentView: View {
  @State private var selectedMenuItemId: MenuItem.ID?
  
  var body: some View {
    List {
      Section {
        navigationLinkForMenuItem(.saved) {
          Label(MenuItem.saved.text, systemImage: MenuItem.saved.systemImage)
        }
      }
      
      Section {
        ForEach(Category.menuItems) { item in
          navigationLinkForMenuItem(item) {
            listRowForCategoryMenuItem(item)
          }
        }
      } header: {
        Text("Categories")
      }
    }
    .searchable(text: .constant(""))
    .navigationTitle("News")
  }
  
  
  @ViewBuilder
  private func viewForMenuItem(_ item: MenuItem) -> some View {
    switch item {
    case .search:
      Text("search")
    case .saved:
      Text("saved")
    case .category(let category):
      NewsTabView(category: category)
    }
  }
  
  private func navigationLinkForMenuItem<Label: View>(_ item: MenuItem, @ViewBuilder label: () -> Label) -> some View {
    NavigationLink(destination: viewForMenuItem(item), tag: item.id, selection: $selectedMenuItemId) {
      label()
    }
    .listItemTint(item.listItemTintColor)
  }
  
  private func listRowForCategoryMenuItem(_ item: MenuItem) -> some View {
    VStack(alignment: .leading, spacing: 8) {
      Image(systemName: item.systemImage)
        .imageScale(.large)
      Text(item.text)
    }
    .padding(.vertical, 10)
  }
}

fileprivate extension MenuItem {
  var listItemTintColor: Color? {
    switch self {
    case .category(let category):
      switch category {
      case .general: return .orange
      case .business: return .cyan
      case .technology: return .blue
      case .entertainment: return .indigo
      case .sports: return .purple
      case .science: return .brown
      case .health: return .red
      }
      //    case .search:
      //    case .saved:
      //    }
    default: return nil
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
