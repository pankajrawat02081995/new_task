//
//  ToolBoxTalkListModel.swift
//  Comezy
//
//  Created by aakarshit on 24/06/22.
//

import Foundation

// MARK: - Welcome
struct ToolBoxTalkListModel: Codable {
    let next, previous: String
    let totalCount: Int
    let results: [ToolBoxTalkListResult]

    enum CodingKeys: String, CodingKey {
        case next, previous
        case totalCount = "total_count"
        case results
    }
}

// MARK: - Result
struct ToolBoxTalkListResult: Codable {
    let id: Int
    let sender: ToolBoxTalkListPerson
    let receiver: [ToolBoxTalkListPerson]
    let createdDate, name, topicOfDiscussion, remedies: String
    let file: [String]
    let senderWatch: String
    let project: Int

    enum CodingKeys: String, CodingKey {
        case id, sender, receiver
        case createdDate = "created_date"
        case name
        case topicOfDiscussion = "topic_of_discussion"
        case remedies, file
        case senderWatch = "sender_watch"
        case project
    }
}

// MARK: - Sender
struct ToolBoxTalkListPerson: Codable {
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
