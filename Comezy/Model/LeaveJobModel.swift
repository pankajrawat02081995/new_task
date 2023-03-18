//
//  LeaveJobModel.swift
//  Comezy
//
//  Created by aakarshit on 23/07/22.
//

import Foundation

// MARK: - Welcome
struct LeaveJobDataClass: Codable {
    let next, previous: String
    let totalCount: Int
    let results: [LeaveJobResult]

    enum CodingKeys: String, CodingKey {
        case next, previous
        case totalCount = "total_count"
        case results
    }
}

// MARK: - Result
struct LeaveJobResult: Codable {
    let project: [LeaveJobProject]
}

// MARK: - Project
struct LeaveJobProject: Codable {
    let id: Int
    let name, createdDate, status, projectDescription: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case createdDate = "created_date"
        case status
        case projectDescription = "description"
    }
}
