//
//  LyftService.swift
//  FryftEats
//
//  Created by Victor Hoang on 4/30/24.
//

import Foundation
import UIKit

class LyftService {
    // Checks if the Lyft app is installed on the user's device.
    func checkLyftAppInstallation() {
        if UIApplication.shared.canOpenURL(URL(string: "lyft://")!) {
            print("Lyft app is installed.")
        } else {
            // Prompt the user to install the Lyft app if it's not found.
            promptToInstallLyft()
        }
    }
    
    // Shows an alert to the user suggesting the installation of the Lyft app.
    private func promptToInstallLyft() {
        // Obtain the top-most view controller to present the alert.
        guard let topController = UIViewController.currentTopMost() else {
            print("No top controller available")
            return
        }
        
        // Setup the alert with an Install button that opens the Lyft app page in the App Store.
        let alert = UIAlertController(title: "Lyft App Not Found", message: "The Lyft app is required to request rides. Would you like to install it now?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Install", style: .default, handler: { _ in
            if let url = URL(string: "https://apps.apple.com/us/app/lyft/id529379082") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        topController.present(alert, animated: true, completion: nil)
    }
}

// UIViewController extension to find the top-most presented view controller for alert presentation.
extension UIViewController {
    // Recursive function to find the top-most view controller.
    static func topMost(of viewController: UIViewController?) -> UIViewController? {
        if let presented = viewController?.presentedViewController {
            return topMost(of: presented)
        }
        if let navigation = viewController as? UINavigationController {
            return topMost(of: navigation.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            return topMost(of: tab.selectedViewController)
        }
        return viewController
    }

    // Finds the top-most view controller in the active application window.
    static func currentTopMost() -> UIViewController? {
        var currentScene: UIWindowScene? = nil
        if #available(iOS 13.0, *) {
            currentScene = UIApplication.shared.connectedScenes
                .filter { $0.activationState == .foregroundActive }
                .first as? UIWindowScene
        } else {
            currentScene = UIApplication.shared.connectedScenes
                .first as? UIWindowScene
        }
        return currentScene?.windows
            .filter { $0.isKeyWindow }
            .first?.rootViewController.flatMap { topMost(of: $0) }
    }
}
