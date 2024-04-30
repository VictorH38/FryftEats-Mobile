//
//  RestaurantDetailsViewModel.swift
//  FryftEats
//
//  Created by Victor Hoang on 4/29/24.
//

import Foundation

class RestaurantDetailsViewModel: ObservableObject {
    @Published var restaurant: Restaurant
    
    init(restaurant: Restaurant) {
        self.restaurant = restaurant
    }
}
