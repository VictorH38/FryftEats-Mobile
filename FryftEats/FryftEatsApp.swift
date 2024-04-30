//
//  FryftEatsApp.swift
//  FryftEats
//
//  Created by Victor Hoang on 4/28/24.
//

import SwiftUI
import UIKit
import LyftSDK

@main
struct FryftEatsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        LyftConfiguration.developer = (token: "your_token_here", clientId: "your_client_id_here")
        return true
    }
}
