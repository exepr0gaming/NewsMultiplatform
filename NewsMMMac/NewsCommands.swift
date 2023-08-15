//
//  NewsCommands.swift
//  NewsMMMac
//
//  Created by Andrew Kurdin on 15.08.2023.
//

import SwiftUI

struct NewsCommands: Commands {
    var body: some Commands {
      CommandGroup(before: .sidebar) {
        BodyView()
          .keyboardShortcut("R", modifiers: [.command])
      }
    }
  
  struct BodyView: View {
    @FocusedValue(\.refreshAction) private var refreshAction: (() -> Void)?
    var body: some View {
      Button("Refresh News") {
        refreshAction?()
      }
    }
  }
}
