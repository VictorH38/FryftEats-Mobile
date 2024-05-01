//
//  SignUpViewModel.swift
//  FryftEats
//
//  Created by Victor Hoang on 4/28/24.
//

import Foundation
import Combine
import UIKit

class SignUpViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var errorMessage: String?
    @Published var isSignUpComplete: Bool = false

    private var cancellables: Set<AnyCancellable> = []

    // Attempts to register a new user with the provided details.
    func signUp() {
        // Ensure the passwords entered match.
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return
        }

        let url = URL(string: "https://fryfteats.com/api/signup")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let body: [String: String] = [
            "firstName": firstName,
            "lastName": lastName,
            "username": username,
            "email": email,
            "password": password,
            "password_confirmation": confirmPassword
        ]
        request.httpBody = try? JSONEncoder().encode(body)

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .flexibleISO8601

        // Network request to send signup details to the server.
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
            .decode(type: SignUpResponse.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                // Handle errors during signup.
                if case let .failure(error) = completion {
                    DispatchQueue.main.async {
                        self.errorMessage = error.localizedDescription
                    }
                }
            }, receiveValue: { response in
                // Successful registration.
                SessionManager.shared.signUp(token: response.token, user: response.user)
                DispatchQueue.main.async {
                    self.isSignUpComplete = true
                    self.errorMessage = nil
                }
            })
            .store(in: &cancellables)
    }
    
    // Dismisses keyboard
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// Data structure to parse the signup response.
struct SignUpResponse: Codable {
    let message: String
    let token: String
    let user: User
}
