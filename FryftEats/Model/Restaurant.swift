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
    var latitude: String?
    var longitude: String?
    var createdAt: Date?
    var updatedAt: Date?
    
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
        case latitude
        case longitude
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case favorites
        case comments
        case reports
    }
    
    init(id: Int? = nil, name: String, address: String, phoneNumber: String? = nil, cuisine: String? = nil, rating: Double? = nil, price: String? = nil, url: String? = nil, imageUrl: String? = nil, latitude: String? = nil, longitude: String? = nil, createdAt: Date? = nil, updatedAt: Date? = nil, favorites: [User]? = nil, comments: [Comment]? = nil, reports: [Report]? = nil) {
        self.id = id
        self.name = name
        self.address = address
        self.phoneNumber = phoneNumber
        self.cuisine = cuisine
        self.rating = rating
        self.price = price
        self.url = url
        self.imageUrl = imageUrl
        self.latitude = latitude
        self.longitude = longitude
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.favorites = favorites
        self.comments = comments
        self.reports = reports
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try? container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        address = try container.decode(String.self, forKey: .address)
        phoneNumber = try? container.decode(String.self, forKey: .phoneNumber)
        cuisine = try? container.decode(String.self, forKey: .cuisine)
        rating = try? container.decode(Double.self, forKey: .rating)
        price = try? container.decode(String.self, forKey: .price)
        url = try? container.decode(String.self, forKey: .url)
        imageUrl = try? container.decode(String.self, forKey: .imageUrl)
        latitude = try? container.decode(String.self, forKey: .latitude)
        longitude = try? container.decode(String.self, forKey: .longitude)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        if let createdAtString = try? container.decode(String.self, forKey: .createdAt),
           let date = dateFormatter.date(from: createdAtString) {
            createdAt = date
        } else {
            createdAt = nil
        }

        if let updatedAtString = try? container.decode(String.self, forKey: .updatedAt),
           let date = dateFormatter.date(from: updatedAtString) {
            updatedAt = date
        } else {
            updatedAt = nil
        }
    }
}

extension Restaurant {
    static var sampleRestaurants: [Restaurant] {
        [
            Restaurant(
                id: 1,
                name: "Pot of Cha",
                address: "3013 S Figueroa St, Los Angeles, CA 90007",
                phoneNumber: "(213) 516-1888",
                cuisine: "Bubble Tea, Coffee & Tea, Juice Bars & Smoothies",
                rating: 4.5,
                price: "$$",
                url: "https://www.yelp.com/biz/pot-of-cha-los-angeles?adjust_creative=HcTws1zsDWAeEmQWEvZw5g&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=HcTws1zsDWAeEmQWEvZw5g",
                imageUrl: "https://s3-media2.fl.yelpcdn.com/bphoto/N6xoZa0EuKBX2WIV22FeNQ/o.jpg",
                latitude: "34.0224",
                longitude: "-118.2851"
            ),
            Restaurant(
                id: 2,
                name: "The Coffee Bean",
                address: "3000 S Hoover St, Los Angeles, CA 90007",
                phoneNumber: "(213) 741-1291",
                cuisine: "Coffee & Tea",
                rating: 4.0,
                price: "$",
                url: "https://www.yelp.com/biz/the-coffee-bean-los-angeles-2?adjust_creative=HcTws1zsDWAeEmQWEvZw5g&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=HcTws1zsDWAeEmQWEvZw5g",
                imageUrl: "https://s3-media1.fl.yelpcdn.com/bphoto/Co4lCmZGR4Np0PTibwb5ig/o.jpg",
                latitude: "34.0284",
                longitude: "-118.2871"
            )
        ]
    }
}
