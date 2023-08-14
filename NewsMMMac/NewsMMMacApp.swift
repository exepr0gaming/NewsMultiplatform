//
//  NewsMMMacApp.swift
//  NewsMMMac
//
//  Created by Andrew Kurdin on 14.08.2023.
//

import SwiftUI

@main
struct NewsMMMacApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .commands {
          SidebarCommands() // позволяет вкл sidebar, view -> Show sidebar
        }
    }
}
