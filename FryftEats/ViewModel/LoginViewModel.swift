//
//  LoginViewModel.swift
//  FryftEats
//
//  Created by Victor Hoang on 4/28/24.
//

import Foundation
import Combine
import UIKit
import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false

    private var cancellables: Set<AnyCancellable> = []
    
    // Attempts to log in the user using provided credentials.
    func login(username: String, password: String, errorMessage: Binding<String?>) {
        let url = URL(string: "https://fryfteats.com/api/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let body: [String: String] = [
            "username": username,
            "password": password
        ]
        request.httpBody = try? JSONEncoder().encode(body)
    
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .flexibleISO8601

        // Starts the network request to log in.
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                if response.statusCode == 200 {
                    return output.data
                } else {
                    let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: output.data)
                    throw NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: errorResponse.message])
                }
            }
            .decode(type: LoginResponse.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                // Handles error in case of failure.
                if case let .failure(error) = completion {
                    errorMessage.wrappedValue = error.localizedDescription
                }
            }, receiveValue: { response in
                // Sets the login state on successful login.
                SessionManager.shared.login(token: response.token, user: response.user)
                self.isLoggedIn = true
                errorMessage.wrappedValue = nil
            })
            .store(in: &cancellables)
    }
    
    // Dismisses keyboard
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// Structures to parse the login response.
struct LoginResponse: Codable {
    let message: String
    let token: String
    let user: User
}

struct ErrorResponse: Codable {
    let message: String
}
