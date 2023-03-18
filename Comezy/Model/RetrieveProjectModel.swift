//
//  RetrieveProjectModel.swift
//  Comezy
//
//  Created by shiphul on 01/12/21.
//

import Foundation

struct RetrieveProjectModel: Codable {
    var id: Int?
    var name: String?
    var address: Address?
    var client: Client?
    var description: String?
    var scope_of_work: [String]
    var created_date, last_updated, status: String?
    var quotations: [String]?
    var owner: Client?

    enum CodingKeys: String, CodingKey {
        case id, name, address, client
        case description
        case scope_of_work
        case created_date
        case last_updated
        case status, quotations, owner
    }
}

// MARK: - Address
struct Address: Codable {
    var name: String?
    var longitude, latitude: Float?
}

// MARK: - Client
struct Client: Codable {
    var id: Int?
    var firstName, lastName, phone, profilePicture, email: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case phone, email
        case profilePicture="profile_picture"
    }
    func clientFullName()->String?{
        return (self.firstName! + " " + self.lastName!)
    }
}
             
