//
//  Comment.swift
//  FryftEats
//
//  Created by Victor Hoang on 4/28/24.
//

import Foundation

class Comment: Codable {
    var id: Int?
    var userId: Int
    var restaurantId: Int
    var body: String
    var createdAt: Date?
    var updatedAt: Date?
    
    var user: User?
    var restaurant: Restaurant?

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case restaurantId = "restaurant_id"
        case body
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case user
        case restaurant
    }

    init(id: Int? = nil, userId: Int, restaurantId: Int, body: String, createdAt: Date? = nil, updatedAt: Date? = nil, user: User? = nil, restaurant: Restaurant? = nil) {
        self.id = id
        self.userId = userId
        self.restaurantId = restaurantId
        self.body = body
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.user = user
        self.restaurant = restaurant
    }
}
