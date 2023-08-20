//
//  ContentView.swift
//  NewsTV
//
//  Created by Andrew Kurdin on 20.08.2023.
//

import SwiftUI

struct ContentView: View {
  
  @State private var selectedMenuItemId: MenuItem.ID?
  //@AppStorage("selectedMenuItemId") private var selectedMenuItemId: MenuItem.ID?
  
  var body: some View {
    TabContentView(selectedMenuItemId: $selectedMenuItemId)
  }
  
  
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
