//
//  NewsMultiplatformApp.swift
//  NewsMultiplatform
//
//  Created by Andrew Kurdin on 09.08.2023.
//

import SwiftUI
import UIKit


class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    
    UNUserNotificationCenter.current().delegate = self
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { success, error in
      print("@@@success AppDelegate")
      print("@@@error AppDelegate, \(error?.localizedDescription ?? "No error for auth permission")")
    }
    return true
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([.sound, .banner])
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    if let urlString = response.notification.request.content.userInfo["url"] as? String,
       let url = URL(string: urlString) {
      NotificationCenter.default.post(name: .articleSent, object: nil, userInfo: ["url": url])
    }
  }
  
}

@main
struct NewsMultiplatformApp: App {
  
  @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
  @StateObject private var articleBookmarkVM = ArticleBookmarkViewModel.shared
  @StateObject private var connectivityVM = WatchConnectivityViewModel.shared
  
  var body: some Scene {
    WindowGroup {
        ContentView()
        .environmentObject(articleBookmarkVM)
       // .environmentObject(connectivityVM)
    }
  }
}
