//
//  SafetyModel.swift
//  Comezy
//
//  Created by aakarshit on 27/06/22.
//

import Foundation
// MARK: - Welcome
struct SafetyListModel: Codable {
    let next, previous: String
    let totalCount: Int
    let results: [SafetyListResult]

    enum CodingKeys: String, CodingKey {
        case next, previous
        case totalCount = "total_count"
        case results
    }
}

// MARK: - Result
struct SafetyListResult: Codable {
    let id: Int
    let name, resultDescription: String
    let file: [String]
    let type, createdDate, updatedDate, workerWatch: String
    let clientWatch: String
    let project, createdBy: Int

    enum CodingKeys: String, CodingKey {
        case id, name
        case resultDescription = "description"
        case file, type
        case createdDate = "created_date"
        case updatedDate = "updated_date"
        case workerWatch = "worker_watch"
        case clientWatch = "client_watch"
        case project
        case createdBy = "created_by"
    }
}
