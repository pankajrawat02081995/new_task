//
//  AddCommentModel.swift
//  Comezy
//
//  Created by shiphul on 24/12/21.
//

import Foundation

struct AddCommentModel: Codable {
    let id: Int
    let comment, createdTime: String
    let user: CommentUser

    enum CodingKeys: String, CodingKey {
        case id, comment
        case createdTime = "created_time"
        case user
    }
}

// MARK: - User
struct CommentUser: Codable {
    let id: Int
    let firstName, lastName, profilePicture: String

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case profilePicture = "profile_picture"
    }
}
