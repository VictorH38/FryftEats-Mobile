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
                imageUrl: "https://s3-media2.fl.yelpcdn.com/bphoto/N6xoZa0EuKBX2WIV22FeNQ/o.jpg"
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
                imageUrl: "https://s3-media1.fl.yelpcdn.com/bphoto/Co4lCmZGR4Np0PTibwb5ig/o.jpg"
            )
        ]
    }
}
