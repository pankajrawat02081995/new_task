//
//  File.swift
//  Comezy
//
//  Created by aakarshit on 09/06/22.
//

import Foundation


// MARK: - Welcome
struct ROIDetailModel: Codable {
    let id: Int
    let action, name, infoNeeded: String
    let file: [String]
    let createdDate: String
    let project: Int
    let sender: ROIDetailPerson
    let receiver: [ROIDetailPerson]

    enum CodingKeys: String, CodingKey {
        case id, action, name
        case infoNeeded = "info_needed"
        case file
        case createdDate = "created_date"
        case project, sender, receiver
    }
}

// MARK: - ROIDetailPerson
struct ROIDetailPerson: Codable {
    let id: Int
    let firstName, lastName, phone, email: String
    let profilePicture: String
    let occupation: Occupation
    let action: String
    let infoResponse: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case phone, email
        case profilePicture = "profile_picture"
        case occupation, action
        case infoResponse = "info_response"
    }
}
