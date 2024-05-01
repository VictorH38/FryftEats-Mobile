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

    // Initialize with a list of restaurants and a flag indicating if this list is for favorites.
    init(restaurants: [Restaurant] = [], isFavoritesList: Bool) {
        self.restaurants = restaurants
        self.isFavoritesList = isFavoritesList
    }
    
    // Remove a restaurant from the list by its ID, only if the list is a favorites list.
    func removeRestaurant(byId id: Int) {
        if isFavoritesList {
            DispatchQueue.main.async {
                self.restaurants.removeAll { $0.id == id }
            }
        }
    }
}
