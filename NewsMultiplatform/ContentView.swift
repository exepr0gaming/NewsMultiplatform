//
//  ContentView.swift
//  NewsMultiplatform
//
//  Created by Andrew Kurdin on 09.08.2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
         NewsTabView()
            .tabItem {
              Label("News", systemImage: "newspaper")
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
