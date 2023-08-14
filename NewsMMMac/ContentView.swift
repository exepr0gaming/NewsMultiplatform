//
//  ContentView.swift
//  NewsMMMac
//
//  Created by Andrew Kurdin on 14.08.2023.
//

import SwiftUI

struct ContentView: View {
  
  @SceneStorage("selectedMenuItemId") private var selectedMenuItemId: MenuItem.ID? // analog appStorage, сохраняет значение для определенной сцены(окна) тк приложение может работать в нескольких окнах
  private var selection: Binding<MenuItem.ID?> {
    Binding {
      selectedMenuItemId ?? MenuItem.category(.general).id
    } set: { newValue in
      if let newValue = newValue {
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
    }
  
  private func toggleSidebar() {
    NSApp.keyWindow?.firstResponder?
      .tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
