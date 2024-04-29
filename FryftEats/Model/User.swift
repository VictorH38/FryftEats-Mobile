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
    var emailVerifiedAt: Date?
    var createdAt: Date?
    var updatedAt: Date?

    var favorites: [Restaurant]?
    var comments: [Comment]?
    var reports: [Report]?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case username
        case emailVerifiedAt = "email_verified_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case favorites
        case comments
        case reports
    }

    init(id: Int? = nil, firstName: String, lastName: String, email: String, username: String, emailVerifiedAt: Date? = nil, createdAt: Date? = nil, updatedAt: Date? = nil, favorites: [Restaurant]? = nil, comments: [Comment]? = nil, reports: [Report]? = nil) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.username = username
        self.emailVerifiedAt = emailVerifiedAt
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.favorites = favorites
        self.comments = comments
        self.reports = reports
    }
}
