//
//  ShareButton.swift
//  FryftEats
//
//  Created by Victor Hoang on 4/30/24.
//

import Foundation
import SwiftUI
import MessageUI

struct ShareButton: View {
    var restaurant: Restaurant
    @State private var isShowingMessageComposer = false

    var body: some View {
        Button(action: {
            self.isShowingMessageComposer = true
        }) {
            Image(systemName: "square.and.arrow.up")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
                .padding()
        }
        .background(Color.white)
        .foregroundColor(.blue)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .sheet(isPresented: $isShowingMessageComposer) {
            MessageComposerView(isPresented: $isShowingMessageComposer, messageBody: "Check out \(restaurant.name) on FryftEats! Here's the link: \(restaurant.url ?? "Link not available")\nDownload FryftEats to discover more amazing places!")
        }
    }
}

struct MessageComposerView: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    var messageBody: String
    
    func makeUIViewController(context: Context) -> MessageHostingController {
        MessageHostingController(messageBody: messageBody, onDismiss: {
            self.isPresented = false
        })
    }
    
    func updateUIViewController(_ uiViewController: MessageHostingController, context: Context) {}
}
