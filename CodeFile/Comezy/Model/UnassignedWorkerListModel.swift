//
//  UnassignedWorkerListModel.swift
//  Comezy
//
//  Created by shiphul on 16/12/21.
//

import Foundation

struct Workers: Codable {
    var next: String?
    var previous: String?
    var totalCount: Int?
    var results: [WorkersResult]?

    enum CodingKeys: String, CodingKey {
        case next, previous
        case totalCount = "total_count"
        case results
    }
}

// MARK: - Result
struct WorkersResult: Codable {
    var id: Int?
    var firstName : String?
    var lastName: String?
    var phone: String?
    var email: String?
    var profilePicture: String?
    var occupation: WorkerOccupation?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case phone, email
        case profilePicture = "profile_picture"
        case occupation
    }
}

// MARK: - Occupation
struct WorkerOccupation: Codable {
    var id: Int?
    var name: String?
}
