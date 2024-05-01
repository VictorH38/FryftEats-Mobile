//
//  MessageHostingController.swift
//  FryftEats
//
//  Created by Victor Hoang on 4/30/24.
//

import Foundation
import UIKit
import MessageUI
import SwiftUI

// UIViewController subclass to host an MFMessageComposeViewController for sending SMS messages.
class MessageHostingController: UIViewController {
    var messageBody: String
    var onDismiss: () -> Void

    // Initializes the controller with a message body and a closure to execute upon dismissal.
    init(messageBody: String, onDismiss: @escaping () -> Void) {
        self.messageBody = messageBody
        self.onDismiss = onDismiss
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Presents the message compose view controller shortly after the view appears.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.presentMessageCompose()
        }
    }

    // Presents the message compose interface if possible.
    private func presentMessageCompose() {
        if MFMessageComposeViewController.canSendText() {
            let messageVC = MFMessageComposeViewController()
            messageVC.body = messageBody
            messageVC.messageComposeDelegate = self
            self.present(messageVC, animated: true) {
                print("Message compose view presented")
            }
        } else {
            print("Cannot send text")
            self.dismiss(animated: true, completion: onDismiss)
        }
    }
}

// Conforms to MFMessageComposeViewControllerDelegate to handle the message composition result.
extension MessageHostingController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        print("Message compose view is dismissing")
        controller.dismiss(animated: true, completion: onDismiss)
    }
}
