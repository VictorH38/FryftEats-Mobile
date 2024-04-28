//
//  SessionManager.swift
//  FryftEats
//
//  Created by Victor Hoang on 4/28/24.
//

import Foundation

class SessionManager: ObservableObject {
    static let shared = SessionManager()
    @Published var token: String?
    @Published var isLoggedIn: Bool = false
    @Published var user: User?

    private init() {}

    func login(token: String, user: User) {
        self.token = token
        self.user = user
        self.isLoggedIn = true
        UserDefaults.standard.set(token, forKey: "authToken")
    }
    
    func signUp(token: String, user: User) {
        login(token: token, user: user)
    }

    func logout() {
        self.token = nil
        self.user = nil
        self.isLoggedIn = false
        UserDefaults.standard.removeObject(forKey: "authToken")
    }

    func loadToken() -> String? {
        return UserDefaults.standard.string(forKey: "authToken")
    }
}
