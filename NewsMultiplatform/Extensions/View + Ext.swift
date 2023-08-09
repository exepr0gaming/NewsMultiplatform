//
//  View + Ext.swift
//  NewsMultiplatform
//
//  Created by Andrew Kurdin on 09.08.2023.
//

import SwiftUI

extension View {
  func presentShareSheet(url: URL) {
    let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
    (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
      .keyWindow?
      .rootViewController?
      .present(activityVC, animated: true)
  }
}
