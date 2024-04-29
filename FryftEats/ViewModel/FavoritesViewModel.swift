//
//  FavoritesViewModel.swift
//  FryftEats
//
//  Created by Victor Hoang on 4/29/24.
//

import Foundation

class FavoritesViewModel: ObservableObject {
    @Published var restaurants: [Restaurant] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false

    init() {
        fetchFavorites()
    }

    func fetchFavorites() {
        guard SessionManager.shared.isLoggedIn,
              let token = SessionManager.shared.token,
              let userId = SessionManager.shared.user?.id else {
            self.errorMessage = "Please login to view favorites."
            return
        }

        isLoading = true
        let endpoint = "https://fryfteats.com/api/users/\(userId)/favorites"
        guard let url = URL(string: endpoint) else {
            self.errorMessage = "Invalid URL"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .flexibleISO8601

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
            }
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  error == nil else {
                DispatchQueue.main.async {
                    self?.errorMessage = "Network or server error occurred."
                }
                return
            }

            if response.statusCode == 200 {
                do {
                    let decodedResponse = try decoder.decode(FavoritesResponse.self, from: data)
                    DispatchQueue.main.async {
                        self?.restaurants = decodedResponse.data
                    }
                } catch {
                    DispatchQueue.main.async {
                        self?.errorMessage = "Failed to decode favorites."
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self?.errorMessage = "Failed to load favorites: \(response.statusCode)"
                }
            }
        }.resume()
    }
}

struct FavoritesResponse: Codable {
    let data: [Restaurant]
}
