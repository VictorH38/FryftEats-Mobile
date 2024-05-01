//
//  ReportViewModel.swift
//  FryftEats
//
//  Created by Victor Hoang on 4/30/24.
//

import Foundation
import Combine

class ReportViewModel: ObservableObject {
    @Published var restaurants: [Restaurant] = []
    @Published var selectedRestaurantId: Int?
    @Published var reason: String = "Outside of Fryft zone"
    @Published var additionalNotes: String = ""
    @Published var successMessage: String?
    @Published var errorMessage: String?
    @Published var isLoading = false
    @Published var isSuccess = false
    
    private var cancellables: Set<AnyCancellable> = []
    private var isInitiatedFromDetails: Bool

    init(restaurantId: Int? = nil) {
        self.isInitiatedFromDetails = restaurantId != nil
        self.selectedRestaurantId = restaurantId
        fetchRestaurants()
    }

    func fetchRestaurants() {
        isLoading = true
        let url = URL(string: "https://fryfteats.com/api/restaurants?sort=name&order=asc")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .flexibleISO8601
        
        URLSession.shared.dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
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
            .decode(type: RestaurantResponse.self, decoder: decoder)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case let .failure(error) = completion {
                    self?.errorMessage = "Failed to fetch restaurants: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] response in
                self?.restaurants = response.data
                if !self!.isInitiatedFromDetails {
                    self?.selectedRestaurantId = response.data.first?.id
                }
                self?.reason = "Outside of Fryft zone"
                self?.additionalNotes = ""
                self?.successMessage = nil
                self?.errorMessage = nil
            })
            .store(in: &cancellables)
    }

    func submitReport() {
        guard let restaurantId = selectedRestaurantId else {
            errorMessage = "Please select a restaurant."
            return
        }
        guard !reason.isEmpty else {
            errorMessage = "Please select a reason for the report."
            return
        }

        isLoading = true
        let endpoint = SessionManager.shared.isLoggedIn ? "reports/authenticated" : "reports"
        guard let url = URL(string: "https://fryfteats.com/api/\(endpoint)") else {
            errorMessage = "Invalid URL"
            return
        }
        
        print("restaurant id: \(restaurantId)")
        print("reason: \(reason)")
        print("additionalNotes: \(additionalNotes)")

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if SessionManager.shared.isLoggedIn {
            if let token = SessionManager.shared.token {
                request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
        }
        
        let body: [String: Any] = [
            "restaurant_id": restaurantId,
            "reason": reason,
            "notes": additionalNotes,
            "status": "Pending"
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    self.errorMessage = "Error: \(error.localizedDescription)"
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 201 {
                        self.isSuccess = true
                        self.successMessage = "Report successfully submitted"
                        self.errorMessage = nil
                    } else {
                        let responseString = String(data: data ?? Data(), encoding: .utf8) ?? "No data"
                        print("Failed to submit report: \(httpResponse.statusCode) - \(responseString)")
                    }
                } else {
                    self.errorMessage = "Failed to submit report"
                }
            }
        }.resume()
    }
}

struct RestaurantResponse: Codable {
    let data: [Restaurant]
}
