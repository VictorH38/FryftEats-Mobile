//
//  Restaurant.swift
//  FryftEats
//
//  Created by Victor Hoang on 4/28/24.
//

import Foundation

class Restaurant: Codable {
    var id: Int?
    var name: String
    var address: String
    var phoneNumber: String?
    var cuisine: String?
    var rating: Double?
    var price: String?
    var url: String?
    var imageUrl: String?
    
    var favorites: [User]?
    var comments: [Comment]?
    var reports: [Report]?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case address
        case phoneNumber = "phone_number"
        case cuisine
        case rating
        case price
        case url
        case imageUrl = "image_url"
        case favorites
        case comments
        case reports
    }

    init(id: Int? = nil, name: String, address: String, phoneNumber: String? = nil, cuisine: String? = nil, rating: Double? = nil, price: String? = nil, url: String? = nil, imageUrl: String? = nil, favorites: [User]? = nil, comments: [Comment]? = nil, reports: [Report]? = nil) {
        self.id = id
        self.name = name
        self.address = address
        self.phoneNumber = phoneNumber
        self.cuisine = cuisine
        self.rating = rating
        self.price = price
        self.url = url
        self.imageUrl = imageUrl
        self.favorites = favorites
        self.comments = comments
        self.reports = reports
    }
}
