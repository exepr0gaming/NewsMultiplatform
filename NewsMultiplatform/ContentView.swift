//
//        ContentView.swift
//  NewsMultiplatform
//
//  Created by Andrew Kurdin on 09.08.2023.
//

import SwiftUI

struct ContentView: View {
  @AppStorage("selectedMenuItemId") private var selectedMenuItemId: MenuItem.ID?
  @Environment(\.horizontalSizeClass) private var horizontalSizeClass
  
  var body: some View {
    switch horizontalSizeClass {
    case .regular:
      SidebarContentView(selectedMenuItemId: $selectedMenuItemId)
//      Text("regular")
//    case .compact:
//      Text("compact")
    default:
      TabContentView(selectedMenuItemId: $selectedMenuItemId)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
     ContentView()
  }
}
