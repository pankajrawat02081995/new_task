//
//  ToolBoxTalkDetailModel.swift
//  Comezy
//
//  Created by aakarshit on 24/06/22.
//

import Foundation
// MARK: - Welcome
struct ToolBoxTalkDetailModel: Codable {
    let id: Int
    let action, name, topicOfDiscussion, remedies: String
    let file: [String]
    let createdDate: String
    let sender: ToolBoxTalkPerson
    let receiver: [ToolBoxTalkPerson]
    let project: Int

    enum CodingKeys: String, CodingKey {
        case id, action, name
        case topicOfDiscussion = "topic_of_discussion"
        case remedies, file
        case createdDate = "created_date"
        case sender, receiver, project
    }
}

// MARK: - Sender
struct ToolBoxTalkPerson: Codable {
    let id: Int
    let firstName, lastName, phone, email: String
    let profilePicture: String
    let occupation: Occupation
    let action: String

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case phone, email
        case profilePicture = "profile_picture"
        case occupation, action
    }
}
