//
//  AddSafetyModel.swift
//  Comezy
//
//  Created by aakarshit on 28/06/22.
//

import Foundation

// MARK: - Welcome
struct AddSafetyModel: Codable {
    let id: Int
    let project: Project
    let createdBy: CreatedBy
    let name, welcomeDescription: String
    let file: [String]
    let type, createdDate, updatedDate: String

    enum CodingKeys: String, CodingKey {
        case id, project
        case createdBy = "created_by"
        case name
        case welcomeDescription = "description"
        case file, type
        case createdDate = "created_date"
        case updatedDate = "updated_date"
    }
}

// MARK: - CreatedBy
struct CreatedBy: Codable {
    let id: Int
    let firstName, lastName, email, phone: String
    let profilePicture: String

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email, phone
        case profilePicture = "profile_picture"
    }
}

