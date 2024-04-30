//
//  SearchViewModel.swift
//  FryftEats
//
//  Created by Victor Hoang on 4/29/24.
//

import Foundation

class SearchViewModel: ObservableObject {
    @Published var restaurants: [Restaurant] = []
    var hasSearched: Bool = false

    func searchRestaurants(term: String, price: String, sortBy: String) {
        let formattedPrice = formatPrice(price)
        let sortByParam = formatSortBy(sortBy)
        
        let queryParams: [String: Any] = [
            "term": term,
            "latitude": "34.0259",
            "longitude": "-118.2853",
            "price": formattedPrice,
            "sort_by": sortByParam,
            "radius": "1500",
            "limit": "50"
        ]
        
        let cacheKey = createCacheKey(queryParams: queryParams)
        if let cachedRestaurants = fetchFromCache(cacheKey: cacheKey) {
            self.restaurants = cachedRestaurants
            self.hasSearched = true
            return
        }

        fetchRestaurants(queryParams: queryParams, cacheKey: cacheKey)
        self.hasSearched = true
    }

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
                    self?.cacheResults(cacheKey: cacheKey, restaurants: newRestaurants)
                }
            } catch {
                print("Failed to decode response: \(error.localizedDescription)")
            }
        }.resume()
    }

    private func storeRestaurant(from business: YelpBusiness, completion: @escaping (Restaurant?) -> Void) {
        let restaurant = Restaurant(
            name: business.name,
            address: business.location.displayAddress.joined(separator: ", "),
            phoneNumber: business.displayPhone,
            cuisine: business.categories.map { $0.title }.joined(separator: ", "),
            rating: business.rating,
            price: business.price,
            url: business.url,
            imageUrl: business.imageUrl
        )
        
        guard let url = URL(string: "https://fryfteats.com/api/restaurants") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(restaurant) {
            request.httpBody = jsonData
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .flexibleISO8601

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
        } else {
            completion(nil)
        }
    }
    
    func refreshSearchResults(term: String, price: String, sortBy: String) {
        if self.hasSearched {
            self.restaurants = []
            searchRestaurants(term: term, price: price, sortBy: sortBy)
        }
    }
    
    private func createCacheKey(queryParams: [String: Any]) -> String {
        let sortedParams = queryParams.sorted(by: { $0.key < $1.key })
        return sortedParams.map { "\($0.key)=\($0.value)" }.joined(separator: "&").hashValue.description
    }
    
    private func cacheResults(cacheKey: String, restaurants: [Restaurant]) {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(restaurants) {
            UserDefaults.standard.set(encodedData, forKey: cacheKey)
            UserDefaults.standard.set(Date(), forKey: "\(cacheKey)-timestamp")
        }
    }

    private func fetchFromCache(cacheKey: String) -> [Restaurant]? {
        let currentDate = Date()
        if let timestamp = UserDefaults.standard.object(forKey: "\(cacheKey)-timestamp") as? Date {
            if currentDate.timeIntervalSince(timestamp) < 604800 {
                if let cachedData = UserDefaults.standard.data(forKey: cacheKey),
                    let cachedRestaurants = try? JSONDecoder().decode([Restaurant].self, from: cachedData) {
                    return cachedRestaurants
                }
            }
        }
        return nil
    }

    private func formatPrice(_ price: String) -> String {
        return price == "All Prices" ? "1,2,3,4" : price.filter { $0 == "$" }.count.description
    }

    private func formatSortBy(_ sortBy: String) -> String {
        switch sortBy {
        case "Rating": return "rating"
        case "Review Count": return "review_count"
        case "Distance": return "distance"
        default: return "best_match"
        }
    }
}
