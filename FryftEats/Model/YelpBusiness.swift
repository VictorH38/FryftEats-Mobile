//
//  YelpBusiness.swift
//  FryftEats
//
//  Created by Victor Hoang on 4/29/24.
//

import Foundation

struct YelpSearchResponse: Codable {
    let businesses: [YelpBusiness]
}

struct YelpBusiness: Codable {
    let id: String
    let name: String
    let imageUrl: String
    let isClosed: Bool
    let url: String
    let reviewCount: Int
    let categories: [YelpCategory]
    let rating: Double
    let coordinates: YelpCoordinates
    let transactions: [String]
    let price: String?
    let location: YelpLocation
    let phone: String
    let displayPhone: String
    let distance: Double

    enum CodingKeys: String, CodingKey {
        case id, name, categories, rating, coordinates, transactions, location, phone, distance
        case imageUrl = "image_url"
        case isClosed = "is_closed"
        case url
        case reviewCount = "review_count"
        case price
        case displayPhone = "display_phone"
    }
}

struct YelpCategory: Codable {
    let alias: String
    let title: String
}

struct YelpCoordinates: Codable {
    let latitude: Double
    let longitude: Double
}

struct YelpLocation: Codable {
    let address1: String?
    let address2: String?
    let address3: String?
    let city: String
    let zipCode: String
    let country: String
    let state: String
    let displayAddress: [String]

    enum CodingKeys: String, CodingKey {
        case address1, address2, address3, city, country, state
        case zipCode = "zip_code"
        case displayAddress = "display_address"
    }
}
