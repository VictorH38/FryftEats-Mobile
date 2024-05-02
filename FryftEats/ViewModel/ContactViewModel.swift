//
//  ContactViewModel.swift
//  FryftEats
//
//  Created by Victor Hoang on 5/1/24.
//

import Foundation
import UIKit

class ContactViewModel: ObservableObject {
    // Send an email
    func sendEmail(name: String, email: String, message: String) {
        let subject = "FryftEats Contact Form"
        let body = "Hello, my name is \(name),\n\n\(message)"

        let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let encodedBody = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

        guard let url = URL(string: "mailto:victor.h8.2003@gmail.com?subject=\(encodedSubject)&body=\(encodedBody)") else {
            return
        }

        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    // Dismisses keyboard
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
