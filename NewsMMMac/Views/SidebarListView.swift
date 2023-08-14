//
//  SidebarListView.swift
//  NewsMMMac
//
//  Created by Andrew Kurdin on 14.08.2023.
//

import SwiftUI

struct SidebarListView: View {
  @Binding var selection: MenuItem.ID?
  
    var body: some View {
      ZStack {
        navigationLink
          .opacity(0)
        
        List(selection: $selection) {
          
          Section {
            listRow(MenuItem.saved)
              .tag(MenuItem.saved.id)
          } header: {
            Text("News")
          }
          .collapsible(false) // нельзя свернуть категорию
          
          Section {
            ForEach(Category.menuItems) {
              listRow($0)
                .tag($0.id)
            }
          } header: {
            Text("Categories")
          }
          .collapsible(false) // нельзя свернуть категорию
          
        }
        .listStyle(.sidebar)
        .frame(minWidth: 220)
        .padding(.top)
      }
    }
  
  @ViewBuilder
  private func viewForMenuItem(_ item: MenuItem) -> some View {
    switch item {
    case .saved:
      Text("Saved")
      
    case .search:
      Text("Search")
      
    case .category(let category):
      Text("Category: \(category.text)")
    }
  }
  
  @ViewBuilder
  private var navigationLink: some View {
    if let selectedMenuItem = MenuItem(id: selection) {
      NavigationLink(destination: viewForMenuItem(selectedMenuItem), tag: selectedMenuItem.id, selection: $selection) {
        EmptyView()
      }
    }
  }
  
  private func listRow(_ item: MenuItem) -> some View {
    Label {
      Text(item.text)
        .padding(.leading, 4)
    } icon: {
      Image(systemName: item.systemImage)
    }
    .font(.title2)
    .padding(.vertical, 4)

  }
}

struct SidebarListView_Previews: PreviewProvider {
    static var previews: some View {
      SidebarListView(selection: .constant(nil))
    }
}
