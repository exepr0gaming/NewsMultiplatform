//
//  SafariView.swift
//  NewsMultiplatform
//
//  Created by Andrew Kurdin on 09.08.2023.
//

import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
  let url: URL
  
  func makeUIViewController(context: Context) -> some SFSafariViewController {
    SFSafariViewController(url: url)
  }
  
  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
  
}
