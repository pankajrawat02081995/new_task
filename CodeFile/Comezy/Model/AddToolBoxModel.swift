//
//  AddToolBoxModel.swift
//  Comezy
//
//  Created by aakarshit on 25/06/22.
//

import Foundation

// MARK: - Welcome
struct AddToolBoxModel: Codable {
    let id: Int
    let receiver: [ToolBoxPeron]
    let createdDate, name, topicOfDiscussion, remedies: String
    let file: [String]
    let senderWatch: String
    let sender, project: Int

    enum CodingKeys: String, CodingKey {
        case id, receiver
        case createdDate = "created_date"
        case name
        case topicOfDiscussion = "topic_of_discussion"
        case remedies, file
        case senderWatch = "sender_watch"
        case sender, project
    }
}

// MARK: - Receiver
struct ToolBoxPeron: Codable {
    let id: Int
    let firstName, lastName, phone, email: String
    let profilePicture: String
    let occupation: Occupation

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case phone, email
        case profilePicture = "profile_picture"
        case occupation
    }
}
