//
//  RestaurantViewModel.swift
//  FryftEats
//
//  Created by Victor Hoang on 4/29/24.
//

import Foundation

class RestaurantViewModel: ObservableObject {
    @Published var restaurant: Restaurant
    @Published var isFavoritesList: Bool
    @Published var isFavorite: Bool = false
    @Published var errorMessage: String?
    
    var restaurantListViewModel: RestaurantListViewModel?
    
    // Initialize with specific restaurant details.
    init(restaurant: Restaurant, isFavoritesList: Bool, listViewModel: RestaurantListViewModel?) {
        self.restaurant = restaurant
        self.isFavoritesList = isFavoritesList
        self.restaurantListViewModel = listViewModel
        checkIfFavorite()
    }
    
    // Check if the current restaurant is marked as favorite by the user.
    func checkIfFavorite() {
        guard let token = SessionManager.shared.token, let userId = SessionManager.shared.user?.id, let restaurantId = restaurant.id else {
            self.errorMessage = "User not logged in or token not available"
            return
        }
        
        let url = URL(string: "https://fryfteats.com/api/users/\(userId)/favorites/\(restaurantId)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .flexibleISO8601

        // Make a GET request to fetch favorite status.
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                DispatchQueue.main.async {
                    self.errorMessage = "Network or server error occurred."
                }
                return
            }
            
            if response.statusCode == 200 {
                DispatchQueue.main.async {
                    do {
                        let _ = try decoder.decode(FavoriteResponse.self, from: data)
                        self.isFavorite = true
                    } catch {
                        self.errorMessage = "Failed to decode response."
                    }
                }
            } else if response.statusCode == 404 {
                DispatchQueue.main.async {
                    self.isFavorite = false
                }
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to check favorite status: \(response.statusCode)"
                }
            }
        }.resume()
    }
    
    // Toggle the favorite status of the restaurant.
    func toggleFavorite() {
        guard let token = SessionManager.shared.token, let userId = SessionManager.shared.user?.id, let restaurantId = restaurant.id else {
            self.errorMessage = "User not logged in or token not available"
            return
        }

        let baseURL = "https://fryfteats.com/api/users/\(userId)/favorites"
        let url = URL(string: isFavorite ? "\(baseURL)/\(restaurantId)" : baseURL)!
        var request = URLRequest(url: url)
        request.httpMethod = isFavorite ? "DELETE" : "POST"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        if !isFavorite {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let body = ["restaurant_id": self.restaurant.id]
            request.httpBody = try? JSONEncoder().encode(body)
        }

        // Make a POST or DELETE request to toggle favorite status.
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    self.errorMessage = "No valid response from server"
                }
                return
            }

            DispatchQueue.main.async {
                if response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204 {
                    self.isFavorite.toggle()
                    if !self.isFavorite && self.isFavoritesList {
                        self.restaurantListViewModel?.removeRestaurant(byId: restaurantId)
                    }
                } else {
                    self.errorMessage = "Failed to toggle favorite: \(response.statusCode)"
                }
            }
        }.resume()
    }
    
    // Return the first part of an address.
    func firstPartOfAddress(_ address: String) -> String {
        address.components(separatedBy: ",").first ?? address
    }
    
    // Calculate how much time has passed since a specific date.
    func timeAgo(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

// Structure to decode the favorite status response.
struct FavoriteResponse: Codable {
    var favorite: Favorite
}
