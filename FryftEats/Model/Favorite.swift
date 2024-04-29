//
//  Favorite.swift
//  FryftEats
//
//  Created by Victor Hoang on 4/29/24.
//

import Foundation

class Favorite: Codable {
    var id: Int?
    var userId: Int
    var restaurantId: Int
    var createdAt: Date?
    var updatedAt: Date?

    var user: User?
    var restaurant: Restaurant?

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case restaurantId = "restaurant_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case user
        case restaurant
    }

    init(id: Int? = nil, userId: Int, restaurantId: Int, createdAt: Date? = nil, updatedAt: Date? = nil, user: User? = nil, restaurant: Restaurant? = nil) {
        self.id = id
        self.userId = userId
        self.restaurantId = restaurantId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.user = user
        self.restaurant = restaurant
    }
}
