//
//  LoginViewModel.swift
//  FryftEats
//
//  Created by Victor Hoang on 4/28/24.
//

import Foundation
import Combine

class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var errorMessage: String?

    private var cancellables: Set<AnyCancellable> = []
    
    func login() {
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
                if case let .failure(error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { response in
                SessionManager.shared.login(token: response.token, user: response.user)
                self.isLoggedIn = true
                self.errorMessage = nil
            })
            .store(in: &cancellables)
    }
}

struct LoginResponse: Codable {
    let message: String
    let token: String
    let user: User
}

struct ErrorResponse: Codable {
    let message: String
}
