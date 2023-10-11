//
//  PunchList.swift
//  Comezy
//
//  Created by aakarshit on 17/06/22.
//

import Foundation

// MARK: - PunchListModel
struct PunchListModel: Codable {
    let next, previous: String
    let totalCount: Int
    let results: [PunchListResult]

    enum CodingKeys: String, CodingKey {
        case next, previous
        case totalCount = "total_count"
        case results
    }
}

// MARK: - Result
struct PunchListResult: Codable {
    let id: Int
    let sender: PunchListPerson
    let receiver: [PunchListPerson]
    let createdDate: String
    let checklist: [Checklist]
    let name, resultDescription: String
    let file: [String]
    let senderWatch: String
    let project: Int

    enum CodingKeys: String, CodingKey {
        case id, sender, receiver
        case createdDate = "created_date"
        case checklist, name
        case resultDescription = "description"
        case file
        case senderWatch = "sender_watch"
        case project
    }
}

// MARK: - Checklist
struct Checklist: Codable {
    let id: Int
    let name, status: String
}

// MARK: - Sender
struct PunchListPerson: Codable {
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
