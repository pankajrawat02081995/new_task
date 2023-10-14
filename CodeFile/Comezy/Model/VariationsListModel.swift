//
//  VariationsListModel.swift
//  Comezy
//
//  Created by aakarshit on 26/05/22.
//

import Foundation

struct VariationsListModel: Codable {
    let next: String
    let previous: String
    let totalCount: Int
    let results: [VariationsListResult]

    enum CodingKeys: String, CodingKey {
        case next, previous
        case totalCount = "total_count"
        case results
    }
}

// MARK: - Result
struct VariationsListResult: Codable {
    let id: Int
    let receiver: [Sender]
    let sender: Sender
    let createdDate, name, summary: String
    let gst: Bool
    let file: [String]
    let price, totalPrice, senderWatch: String
    let project: Int
    let variation_status : String?

    enum CodingKeys: String, CodingKey {
        case id, receiver, sender
        case variation_status
        case createdDate = "created_date"
        case name, summary, gst, file, price
        case totalPrice = "total_price"
        case senderWatch = "sender_watch"
        case project
    }
}

// MARK: - Sender
struct Sender: Codable {
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
