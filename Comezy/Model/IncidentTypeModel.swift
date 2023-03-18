//
//  IncidentTypeModel.swift
//  Comezy
//
//  Created by aakarshit on 21/09/22.
//

import Foundation

struct IncidentTypeModel: Codable {
    let next: String
    let previous: String
    let totalCount: Int
    let results: [IncidentTypeResult]

    enum CodingKeys: String, CodingKey {
        case next, previous
        case totalCount = "total_count"
        case results
    }
}

// MARK: - Result
struct IncidentTypeResult: Codable {
    let name: String
    let id: Int
}
