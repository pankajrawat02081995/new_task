//
//  AddPunchModel.swift
//  Comezy
//
//  Created by aakarshit on 21/06/22.
//

import Foundation

// MARK: - Welcome
struct AddPunchModel: Codable {
    let id: Int
    let receiver: [AddPunchReceiver]
    let createdDate: String
    let checklist: [AddPunchChecklist]
    let name, welcomeDescription: String
    let file: [String]
    let senderWatch: String
    let sender, project: Int

    enum CodingKeys: String, CodingKey {
        case id, receiver
        case createdDate = "created_date"
        case checklist, name
        case welcomeDescription = "description"
        case file
        case senderWatch = "sender_watch"
        case sender, project
    }
}

// MARK: - Checklist
struct AddPunchChecklist: Codable {
    let id: Int
    let name, status: String
}

// MARK: - Receiver
struct AddPunchReceiver: Codable {
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
