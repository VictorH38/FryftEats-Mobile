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

    init(restaurants: [Restaurant] = [], isFavoritesList: Bool) {
        self.restaurants = restaurants
        self.isFavoritesList = isFavoritesList
    }
    
    func removeRestaurant(byId id: Int) {
        if isFavoritesList {
            DispatchQueue.main.async {
                self.restaurants.removeAll { $0.id == id }
            }
        }
    }
}
