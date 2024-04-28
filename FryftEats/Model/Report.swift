//
//  Report.swift
//  FryftEats
//
//  Created by Victor Hoang on 4/28/24.
//

import Foundation

class Report: Codable {
    var id: Int?
    var userId: Int?
    var restaurantId: Int
    var reason: String
    var notes: String?
    var status: String
    var createdAt: Date?
    var updatedAt: Date?
    
    var user: User?
    var restaurant: Restaurant?

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case restaurantId = "restaurant_id"
        case reason
        case notes
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case user
        case restaurant
    }

    init(id: Int? = nil, userId: Int? = nil, restaurantId: Int, reason: String, notes: String? = nil, status: String = "Pending", createdAt: Date? = nil, updatedAt: Date? = nil, user: User? = nil, restaurant: Restaurant? = nil) {
        self.id = id
        self.userId = userId
        self.restaurantId = restaurantId
        self.reason = reason
        self.notes = notes
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.user = user
        self.restaurant = restaurant
    }
}
