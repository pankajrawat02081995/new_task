//
//  PunchListDetailModel.swift
//  Comezy
//
//  Created by aakarshit on 17/06/22.
//

import Foundation

struct PunchDetailModel: Codable {
    let id: Int
    let action, name, welcomeDescription: String
    let file: [String]
    let createdDate: String
    let project: Int
    let checklist: [PunchDetailCheckList]
    let sender: PunchDetailSender
    let receiver: [PunchDetailSender]

    enum CodingKeys: String, CodingKey {
        case id, action, name
        case welcomeDescription = "description"
        case file
        case createdDate = "created_date"
        case project, checklist, sender, receiver
    }
}

// MARK: - Checklist
struct PunchDetailCheckList: Codable {
    let id: Int
    let name, status: String
}

// MARK: - Sender
struct PunchDetailSender: Codable {
    let id: Int
    let firstName, lastName, phone, email: String
    let profilePicture: String
    let occupation: Occupation
    let action: String
    let checklist: [Checklist]?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case phone, email
        case profilePicture = "profile_picture"
        case occupation, action, checklist
    }
}


struct EmptyData: Codable {
}

