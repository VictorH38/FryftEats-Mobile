//
//  SearchViewModel.swift
//  FryftEats
//
//  Created by Victor Hoang on 4/29/24.
//

import Foundation
import CryptoKit
import UIKit

class SearchViewModel: ObservableObject {
    @Published var restaurants: [Restaurant] = []
    var hasSearched: Bool = false

    // Initiates a search for restaurants with specified criteria.
    func searchRestaurants(term: String, price: String, sortBy: String) {
        let priceMapping = ["All Prices": "0", "$": "1", "$$": "2", "$$$": "3", "$$$$": "4"]
        let sortMapping = ["Best Match": "best_match", "Review Count": "review_count", "Rating": "rating", "Distance": "distance"]

        let apiUrl = "https://fryfteats.com/api/search"
        guard let url = URL(string: apiUrl) else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let json: [String: Any] = [
            "term": term,
            "price": priceMapping[price] ?? "0",
            "sort_by": sortMapping[sortBy] ?? "best_match"
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: json) else {
            print("Failed to encode JSON")
            return
        }

        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil, let response = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    print("Network or server error occurred.")
                }
                return
            }

            if response.statusCode == 200 {
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .flexibleISO8601
                    
                    let decodedRestaurants = try decoder.decode([Restaurant].self, from: data)
                    DispatchQueue.main.async {
                        self?.restaurants = decodedRestaurants
                        self?.hasSearched = true
                    }
                } catch {
                    DispatchQueue.main.async {
                        print("Failed to decode search results.")
                    }
                }
            } else {
                DispatchQueue.main.async {
                    print("Failed to fetch search results: \(response.statusCode)")
                }
            }
        }.resume()
    }

    // Fetches restaurant data from Yelp API based on search parameters.
    private func fetchRestaurants(queryParams: [String: Any], cacheKey: String) {
        let baseUrl = URL(string: "https://api.yelp.com/v3/businesses/search")!
        var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false)!
        components.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: "\($0.value)") }

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        let apiKey = ProcessInfo.processInfo.environment["YELP_API_KEY"] ?? ""
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                let response = try JSONDecoder().decode(YelpSearchResponse.self, from: data)
                var newRestaurants = [Restaurant]()
                let group = DispatchGroup()

                for business in response.businesses {
                    group.enter()
                    self?.storeRestaurant(from: business) { restaurant in
                        if let restaurant = restaurant {
                            newRestaurants.append(restaurant)
                        }
                        group.leave()
                    }
                }

                group.notify(queue: .main) {
                    self?.restaurants = newRestaurants
                    self?.hasSearched = true
                    self?.storeInCache(restaurants: newRestaurants, cacheKey: cacheKey)
                }
            } catch {
                print("Failed to decode response: \(error.localizedDescription)")
            }
        }.resume()
    }

    // Stores restaurant data fetched from Yelp in the local API for cache.
    private func storeRestaurant(from business: YelpBusiness, completion: @escaping (Restaurant?) -> Void) {
        let restaurantDictionary: [String: Any] = [
            "name": business.name,
            "address": business.location.displayAddress.joined(separator: ", "),
            "phone_number": business.displayPhone,
            "cuisine": business.categories.map { $0.title }.joined(separator: ", "),
            "rating": business.rating,
            "price": business.price!,
            "url": business.url,
            "image_url": business.imageUrl,
            "latitude": String(business.coordinates.latitude),
            "longitude": String(business.coordinates.longitude)
        ]
        
        guard let url = URL(string: "https://fryfteats.com/api/restaurants") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: restaurantDictionary, options: [])
            request.httpBody = jsonData

            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    DispatchQueue.main.async {
                        print("Failed to store restaurant: \(error?.localizedDescription ?? "Unknown error")")
                        completion(nil)
                    }
                    return
                }

                if let response = response as? HTTPURLResponse, response.statusCode == 200 || response.statusCode == 201 {
                    do {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .flexibleISO8601
                        
                        let serverRestaurant = try decoder.decode(Restaurant.self, from: data)
                        DispatchQueue.main.async {
                            completion(serverRestaurant)
                        }
                    } catch {
                        DispatchQueue.main.async {
                            print("Failed to decode restaurant: \(error.localizedDescription)")
                            completion(nil)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        print("Server responded with status code: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
                        completion(nil)
                    }
                }
            }.resume()
        } catch {
            print("Failed to create JSON data: \(error.localizedDescription)")
            completion(nil)
        }
    }

    // Refreshes search results with new parameters without additional searches.
    func refreshSearchResults(term: String, price: String, sortBy: String) {
        if self.hasSearched {
            self.restaurants = []
            searchRestaurants(term: term, price: price, sortBy: sortBy)
        }
    }
    
    // Creates a unique cache key for storing search results.
    private func createCacheKey(queryParams: [String: Any]) -> String {
        let sortedParams = queryParams.sorted(by: { $0.key < $1.key })
        let paramString = sortedParams.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
        
        let hash = SHA256.hash(data: Data(paramString.utf8))
        return "mobile-yelp-search-\(hash.compactMap { String(format: "%02x", $0) }.joined())"
    }
    
    // Retrieves cached search results from a remote server.
    private func getFromCache(cacheKey: String) -> [Restaurant]? {
        guard let url = URL(string: "https://fryfteats.com/api/cache/\(cacheKey)") else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        var restaurants: [Restaurant]? = nil
        let semaphore = DispatchSemaphore(value: 0)

        URLSession.shared.dataTask(with: request) { data, response, error in
            defer { semaphore.signal() }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("No response received.")
                return
            }
            
            if httpResponse.statusCode == 200 {
                guard let data = data else {
                    print("No data received for HTTP status 200.")
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .flexibleISO8601
                    
                    restaurants = try decoder.decode([Restaurant].self, from: data)
                } catch {
                    print("Failed to decode cached data: \(error)")
                }
            }
        }.resume()
        
        semaphore.wait()
        return restaurants
    }

    // Stores the search results to a remote cache.
    private func storeInCache(restaurants: [Restaurant], cacheKey: String) {
        guard let url = URL(string: "https://fryfteats.com/api/cache"), !restaurants.isEmpty else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: Any] = [
            "cache_key": cacheKey,
            "data": restaurants.map { $0.dictionaryRepresentation() }
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("Failed to cache data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            if let data = data, let _ = try? JSONDecoder().decode([String: String].self, from: data) {}
        }.resume()
    }
    
    // Dismisses keyboard
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    // Formats the price filter for API calls.
    private func formatPrice(_ price: String) -> String {
        return price == "All Prices" ? "1,2,3,4" : price.filter { $0 == "$" }.count.description
    }

    // Converts a sort by filter into a query parameter.
    private func formatSortBy(_ sortBy: String) -> String {
        switch sortBy {
        case "Rating": return "rating"
        case "Review Count": return "review_count"
        case "Distance": return "distance"
        default: return "best_match"
        }
    }
}
