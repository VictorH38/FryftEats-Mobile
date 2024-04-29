//
//  RestaurantListViewModel.swift
//  FryftEats
//
//  Created by Victor Hoang on 4/29/24.
//

import Foundation

class RestaurantListViewModel: ObservableObject {
    @Published var restaurants: [Restaurant] = []
    let isFavoritesList: Bool
    let isSearchList: Bool
    @Published var errorMessage: String?

    init(restaurants: [Restaurant] = [], isFavoritesList: Bool, isSearchList: Bool) {
        self.isFavoritesList = isFavoritesList
        self.isSearchList = isSearchList

        if isSearchList {
            self.restaurants = restaurants
        }
    }

    func loadRestaurants() {
        if isFavoritesList {
            fetchFavorites()
        }
    }

    private func fetchFavorites() {
        guard let token = SessionManager.shared.token, let userId = SessionManager.shared.user?.id else {
            print("Authorization token or user ID not found")
            return
        }

        let endpoint = "https://fryfteats.com/api/users/\(userId)/favorites"
        guard let url = URL(string: endpoint) else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .flexibleISO8601

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                DispatchQueue.main.async {
                    self?.errorMessage = "Network or server error occurred."
                }
                return
            }

            if response.statusCode == 200 {
                do {
                    let decodedRestaurants = try decoder.decode([Restaurant].self, from: data)
                    DispatchQueue.main.async {
                        self?.restaurants = decodedRestaurants
                    }
                } catch {
                    DispatchQueue.main.async {
                        self?.errorMessage = "Failed to decode favorites: \(error)"
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
