//
//  ExtensionOfTimeModel.swift
//  Comezy
//
//  Created by aakarshit on 22/06/22.
//

import Foundation
// MARK: - Welcome
struct EOTListModel: Codable {
    let next, previous: String
    let totalCount: Int
    let results: [EOTListResult]

    enum CodingKeys: String, CodingKey {
        case next, previous
        case totalCount = "total_count"
        case results
    }
}

// MARK: - Result
struct EOTListResult: Codable {
    let id: Int
    let sender: EOTPerson
    let receiver: [EOTPerson]
    let createdDate, extendDateFrom, extendDateTo, name: String
    let reasonForDelay, numberOfDays, senderWatch: String
    let project: Int

    enum CodingKeys: String, CodingKey {
        case id, sender, receiver
        case createdDate = "created_date"
        case extendDateFrom = "extend_date_from"
        case extendDateTo = "extend_date_to"
        case name
        case reasonForDelay = "reason_for_delay"
        case numberOfDays = "number_of_days"
        case senderWatch = "sender_watch"
        case project
    }
}

// MARK: - Sender
struct EOTPerson: Codable {
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
