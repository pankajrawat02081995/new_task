//
//  AddROIModel.swift
//  Comezy
//
//  Created by aakarshit on 10/06/22.
//

import Foundation
// MARK: - Welcome
struct AddROIModel: Codable {
    let id: Int
    let receiver: [AddROIReceiver]
    let createdDate, name, infoNeeded: String
    let file: [String]
    let senderWatch: String
    let sender, project: Int

    enum CodingKeys: String, CodingKey {
        case id, receiver
        case createdDate = "created_date"
        case name
        case infoNeeded = "info_needed"
        case file
        case senderWatch = "sender_watch"
        case sender, project
    }
}

// MARK: - Receiver
struct AddROIReceiver: Codable {
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
