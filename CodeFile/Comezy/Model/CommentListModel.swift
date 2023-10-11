//
//  CommentListModel.swift
//  Comezy
//
//  Created by shiphul on 24/12/21.
//

import Foundation
struct CommentListModel: Codable {
    var next, previous: String?
    var totalCount: Int?
    var results: [CommentResult]?

    enum CodingKeys: String, CodingKey {
        case next, previous
        case totalCount = "total_count"
        case results
    }
}

// MARK: - Result
struct CommentResult: Codable {
    var id: Int?
    var createdTime: String?
    var user: User?
    var comment: String?
    var dailylog: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case createdTime = "created_time"
        case user, comment, dailylog
    }
}

// MARK: - User
struct User: Codable {
    var id: Int?
    var firstName, lastName, profilePicture: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case profilePicture = "profile_picture"
    }
}

