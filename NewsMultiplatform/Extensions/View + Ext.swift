//
//  View + Ext.swift
//  NewsMultiplatform
//
//  Created by Andrew Kurdin on 09.08.2023.
//

import SwiftUI

extension View {
  
   func presentShareSheet(url: URL, proxy: GeometryProxy? = nil) {
       let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
       guard let rootVC = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
           .keyWindow?
           .rootViewController else { return }
       
       activityVC.popoverPresentationController?.sourceView = rootVC.view
       if let proxy = proxy {
           activityVC.popoverPresentationController?.sourceRect = proxy.frame(in: .global)
       }
       rootVC.present(activityVC, animated: true)
   }
  
}
