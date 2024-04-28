//
//  SignUpViewModel.swift
//  FryftEats
//
//  Created by Victor Hoang on 4/28/24.
//

import Foundation
import Combine

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

    func signUp() {
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match"
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

        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: SignUpResponse.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { response in
                SessionManager.shared.signUp(token: response.token, user: response.user)
                self.isSignUpComplete = true
            })
            .store(in: &cancellables)
    }
}

struct SignUpResponse: Codable {
    let message: String
    let token: String
    let user: User
}
