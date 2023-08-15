//
//  ContentView.swift
//  NewsMMMac
//
//  Created by Andrew Kurdin on 14.08.2023.
//

import SwiftUI

struct ContentView: View {
  
  @SceneStorage("selectedMenuItemId") private var selectedMenuItemId: MenuItem.ID? // analog appStorage, сохраняет значение для определенной сцены(окна) тк приложение может работать в нескольких окнах
  @EnvironmentObject private var searchVM: ArticleSearchViewModel
  @State private var isSearching = false
  
  private var selection: Binding<MenuItem.ID?> {
    Binding {
      if isSearching {
        return MenuItem.search.id
      }
     return selectedMenuItemId ?? MenuItem.category(.general).id
    } set: { newValue in
      if let newValue = newValue {
        if newValue == MenuItem.search.id {
          isSearching = true
          return
        }
        isSearching = false
        selectedMenuItemId = newValue
      }
    }
  }
  
    var body: some View {
      NavigationView {
        SidebarListView(selection: selection)
          .toolbar {
            ToolbarItem(placement: .navigation) {
              Button {
                toggleSidebar()
              } label: {
                Image(systemName: "sidebar.left")
              }

            }
          }
      }
      .frame(minWidth: 1000, minHeight: 386)
      .searchable(text: $searchVM.searchQuery, placement: .sidebar, prompt: "Search news") {
        suggestionView
      }
      .onSubmit(of: .search) {
        search()
      }
      .focusable()
      // MARK: - Сенсорная панель
      .touchBar {
        ScrollView(.horizontal) {
          HStack {
            ForEach([MenuItem.saved] + Category.menuItems) { item in
              Button {
                selection.wrappedValue = item.id
              } label: {
                Label(item.text, systemImage: item.systemImage)
              }
            }
          }
        }
        .frame(width: 684) // в идеале нужно получить ширину сенсорной панели
        .touchBarItemPresence(.required("menus"))
      }
    }
  
  private func toggleSidebar() {
    NSApp.keyWindow?.firstResponder?
      .tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
  }
  
  private func search() {
    let searchQuery = searchVM.searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
    if !searchQuery.isEmpty {
      searchVM.addHistory(searchQuery)
    } else {
      return
    }
    selection.wrappedValue = MenuItem.search.id
    
    Task {
      await searchVM.searchArticle()
    }
  }
  
  @ViewBuilder
  private var suggestionView: some View {
    Section {
      ForEach(["Swift", "BTC", "IOS"], id: \.self) { tag in
       Text(tag)
//          .frame(maxWidth: .infinity, alignment: .leading) если бы не отрабатывало нажатие вне текста тега, просто по синему фону
//          .background(Color.black.opacity(0.001))
          .searchCompletion(tag)
      }
    } header: {
      Text("Trending")
    }
    
    if !searchVM.history.isEmpty {
      Section {
        ForEach(searchVM.history, id: \.self) { tag in
          Text(tag)
   //          .frame(maxWidth: .infinity, alignment: .leading) если бы не отрабатывало нажатие вне текста тега, просто по синему фону
   //          .background(Color.black.opacity(0.001))
             .searchCompletion(tag)
         }
      } header: {
        Text("Renecet Searches")
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
