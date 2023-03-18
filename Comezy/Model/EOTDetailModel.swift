//
//  EOTDetailModel.swift
//  Comezy
//
//  Created by aakarshit on 22/06/22.
//

import Foundation

// MARK: - Welcome
struct EOTDetailModel: Codable {
    let id: Int
    let action, name, reasonForDelay, numberOfDays: String
    let extendDateFrom, extendDateTo, createdDate: String
    let project: Int
    let sender: Sender
    let receiver: [EOTSender]

    enum CodingKeys: String, CodingKey {
        case id, action, name
        case reasonForDelay = "reason_for_delay"
        case numberOfDays = "number_of_days"
        case extendDateFrom = "extend_date_from"
        case extendDateTo = "extend_date_to"
        case createdDate = "created_date"
        case project, sender, receiver
    }
}

// MARK: - Sender
struct EOTSender: Codable {
    let id: Int
    let firstName, lastName, phone, email: String
    let profilePicture: String
    let occupation: Occupation
    let action: String
    let signature: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case phone, email
        case profilePicture = "profile_picture"
        case occupation, action, signature
    }
}

// MARK: - EOTSubmitResponseModel
struct EOTSubmitResponseModel: Codable {
    let id: Int
    let signature: String
    let action: String
}

