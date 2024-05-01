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

class MessageHostingController: UIViewController {
    var messageBody: String
    var onDismiss: () -> Void

    init(messageBody: String, onDismiss: @escaping () -> Void) {
        self.messageBody = messageBody
        self.onDismiss = onDismiss
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.presentMessageCompose()
        }
    }

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

extension MessageHostingController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        print("Message compose view is dismissing")
        controller.dismiss(animated: true, completion: onDismiss)
    }
}
