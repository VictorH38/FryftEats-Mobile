//
//  User.swift
//  FryftEats
//
//  Created by Victor Hoang on 4/28/24.
//

import Foundation

class User: Codable {
    var id: Int?
    var firstName: String
    var lastName: String
    var email: String
    var username: String

    var favorites: [Restaurant]?
    var comments: [Comment]?
    var reports: [Report]?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case username
        case favorites
        case comments
        case reports
    }

    init(id: Int? = nil, firstName: String, lastName: String, email: String, username: String, favorites: [Restaurant]? = nil, comments: [Comment]? = nil, reports: [Report]? = nil) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.username = username
        self.favorites = favorites
        self.comments = comments
        self.reports = reports
    }
}
