//
//  ROIListModel.swift
//  Comezy
//
//  Created by aakarshit on 09/06/22.
//

import Foundation

// MARK: - ROIListModel
struct ROIListModel: Codable {
    let next, previous: String
    let totalCount: Int
    let results: [ROIListResult]

    enum CodingKeys: String, CodingKey {
        case next, previous
        case totalCount = "total_count"
        case results
    }
}

// MARK: - ROIListResult
struct ROIListResult: Codable {
    let id: Int
    let sender: ROIListPerson
    let receiver: [ROIListPerson]
    let createdDate, name, infoNeeded: String
    let file: [String]
    let senderWatch: String
    let project: Int

    enum CodingKeys: String, CodingKey {
        case id, sender, receiver
        case createdDate = "created_date"
        case name
        case infoNeeded = "info_needed"
        case file
        case senderWatch = "sender_watch"
        case project
    }
}

//Only use this if app crash and sender is different from the one created for variations list

// MARK: - ROIListPerson
struct ROIListPerson: Codable {
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
